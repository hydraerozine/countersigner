import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

actor Countersigner {
    type Asset = {
        assetId : Text;
        name : Text;
        description : Text;
        price : Float;
        link : Text;
        owner : Principal;
        creationDate : Time.Time;
        totalInvested : Float;
        investors : [(Principal, Float)];
        locked : Bool;
        lockExpiry : ?Time.Time;
    };

    private stable var nextAssetId : Nat = 0;
    private var assets = HashMap.HashMap<Text, Asset>(0, Text.equal, Text.hash);
    private var userAssets = HashMap.HashMap<Principal, [Text]>(0, Principal.equal, Principal.hash);

    private func generateUniqueAssetId() : Text {
        nextAssetId += 1;
        "A" # Nat.toText(nextAssetId)
    };

    public shared(msg) func registerUser() : async Text {
        let caller = msg.caller;
        switch (userAssets.get(caller)) {
            case (?_) { "User already registered" };
            case null {
                userAssets.put(caller, []);
                "User registered successfully"
            };
        }
    };

    public shared(msg) func storeAsset(
        name : Text,
        description : Text,
        price : Float,
        link : Text
    ) : async Text {
        let assetId = generateUniqueAssetId();
        let caller = msg.caller;

        let newAsset : Asset = {
            assetId = assetId;
            name = name;
            description = description;
            price = price;
            link = link;
            owner = caller;
            creationDate = Time.now();
            totalInvested = 0;
            investors = [];
            locked = false;
            lockExpiry = null;
        };

        assets.put(assetId, newAsset);

        switch (userAssets.get(caller)) {
            case (?userAssetList) {
                userAssets.put(caller, Array.append(userAssetList, [assetId]));
            };
            case null {
                userAssets.put(caller, [assetId]);
            };
        };

        assetId
    };

    public query func getAsset(assetId : Text) : async ?Asset {
        assets.get(assetId)
    };

    public shared(msg) func getUserAssets() : async [Asset] {
        let caller = msg.caller;
        switch (userAssets.get(caller)) {
            case (null) { [] };
            case (?assetIds) {
                Array.mapFilter<Text, Asset>(assetIds, func(id) { assets.get(id) })
            };
        }
    };

    public query func getAllAssets() : async [Asset] {
        Iter.toArray(assets.vals())
    };

    public shared(msg) func investInAsset(assetId : Text, amount : Float) : async Text {
        let caller = msg.caller;
        switch (assets.get(assetId)) {
            case (null) { "Asset not found" };
            case (?asset) {
                if (asset.locked) { return "Asset is locked" };
                
                let newTotalInvested = asset.totalInvested + amount;
                let newInvestors = Array.append(asset.investors, [(caller, amount)]);
                
                let updatedAsset : Asset = {
                    assetId = asset.assetId;
                    name = asset.name;
                    description = asset.description;
                    price = asset.price;
                    link = asset.link;
                    owner = asset.owner;
                    creationDate = asset.creationDate;
                    totalInvested = newTotalInvested;
                    investors = newInvestors;
                    locked = newTotalInvested >= asset.price;
                    lockExpiry = if (newTotalInvested >= asset.price) ?Time.now() else null;
                };
                
                assets.put(assetId, updatedAsset);
                
                if (updatedAsset.locked) {
                    "Investment successful. Asset is now fully funded and locked for 3 weeks."
                } else {
                    "Investment successful. Asset still needs " # Float.toText(asset.price - newTotalInvested) # " to be fully funded."
                }
            };
        }
    };
}