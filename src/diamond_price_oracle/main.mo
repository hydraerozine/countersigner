import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import JSON "mo:serde/JSON";
//import the custom types we have in Types.mo
import Types "Types";
import DiamondTypes "diamond.types";

actor {

    //function to transform the response
    public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
        let transformed : Types.CanisterHttpResponsePayload = {
            status = raw.response.status;
            body = raw.response.body;
            headers = [
                {
                    name = "Content-Security-Policy";
                    value = "default-src 'self'";
                },
                {
                    name = "Referrer-Policy";
                    value = "strict-origin";
                },
                {
                    name = "Permissions-Policy";
                    value = "geolocation=(self)";
                },
                {
                    name = "Strict-Transport-Security";
                    value = "max-age=63072000";
                },
                {
                    name = "X-Frame-Options";
                    value = "DENY";
                },
                {
                    name = "X-Content-Type-Options";
                    value = "nosniff";
                },
            ];
        };
        transformed;
    };

    public func get_diamond_price(
        queryParams : Types.QueryParams
    ) : async Text {
        //We need this so we can use it to make the HTTP request
        let ic : Types.IC = actor ("aaaaa-aa");

        let url = "https://ii.api.prod.rapnet.com/api/Feeds/2bc9b33b-5890-450c-8e36-5e134bed697b/DiamondsListings/v2";

        let request_headers = [
            { name = "accept"; value = "application/json, text/plain, */*" },
            { name = "content-type"; value = "application/json" },
        ];

        let body_json_text : Text = "
    {
    \"shapes\":[],
    \"sizeFrom\":0.2,
    \"sizeTo\":15,
    \"colors\":
      { \"colorFrom\":\"M\",
        \"colorTo\":\"D\",
        \"fancyColors\":[],
        \"searchType\":\"White\"
      },
    \"clarityFrom\":\"I1\",
    \"clarityTo\":\"IF\",
    \"cutFrom\":\"Poor\",
    \"cutTo\":\"Excellent\",
    \"polishFrom\":\"Poor\",
    \"polishTo\":\"Excellent\",
    \"symmetryFrom\":\"Poor\",
    \"symmetryTo\":\"Excellent\",
    \"fluorescenceIntensities\":[],
    \"labs\":[],\"priceTotalFrom\":1,
    \"priceTotalTo\":1000000,
    \"isFancyColor\":false,
    \"pagination\":
        { \"pageNumber\": " # Nat.toText(queryParams.pageNumber) # ",
          \"pageSize\": " # Nat.toText(queryParams.pageSize) # ",
          \"sortBy\":\"price\",
          \"sortDirection\":\"asc\"
        }
    }";

        // TODO: change pageNumber and pageSize
        let body : Blob = Text.encodeUtf8(body_json_text);
        let request_body_as_nat8 : [Nat8] = Blob.toArray(body); // e.g [34, 34,12, 0]

        let transform_context : Types.TransformContext = {
            function = transform;
            context = Blob.fromArray([]);
        };

        let http_request : Types.HttpRequestArgs = {
            url = url;
            max_response_bytes = null; //optional for request
            headers = request_headers;
            //note: type of `body` is ?[Nat8] so we pass it here as "?request_body_as_nat8" instead of "request_body_as_nat8"
            body = ?request_body_as_nat8;
            method = #post;
            transform = ?transform_context;
        };

        //The way Cycles.add() works is that it adds those cycles to the next asynchronous call
        //See: https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-http_request
        // TODO: read on this
        Cycles.add(230_850_258_000);
        let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);

        let response_body : Blob = Blob.fromArray(http_response.body);
        let decoded_text : Text = switch (Text.decodeUtf8(response_body)) {
            case (null) { "No value returned" };
            case (?y) { y };
        };

        decoded_text;
    };

    public func get_diamond_price_mock() : async Result.Result<?DiamondTypes.Data, Text> {

        let response_text = "
    {
      \"id\":12603993,
      \"sellerId\":23616,
      \"stockNumber\":
      \"56107540\",
      \"diamondMedia\":[{\"type\":\"Video\",\"url\":\"https://v3603660.v360.in/vision360.html?d=6442894421\"}],
      \"shape\":\"Round\",
      \"carat\":0.34,
      \"color\":
        {
          \"colorType\":\"White\",
          \"colorIntensity\":\"\",
          \"fancyColor\":\"\",
          \"fancyColorOvertone\":\"\",
          \"secondaryFancyColor\":\"\",
          \"color\":\"M\"
        },
      \"clarity\":\"SI2\",
      \"cut\":\"Excellent\",
      \"polish\":\"Excellent\",
      \"symmetry\":\"Excellent\",
      \"gradingReport\":
          {
            \"lab\":\"GIA\",
            \"certificateNumber\":\"6442894421\",
            \"certificateURL\":[]
          },
      \"price\":
          {
            \"totalPrice\":239.0,
            \"listingPrice\":84.0,
            \"discount\":0.0,
            \"pricePerCarat\":245.0,
            \"totalPriceInUSD\":239.0
          },
      \"measurements\":
          {
            \"width\":4.5,
            \"length\":4.48,
            \"height\":2.79
          },
      \"depthPct\":62.1,
      \"tablePct\":56.0,
      \"girdleFrom\":\"M\",
      \"girdleTo\":\"STK\",
      \"culet\":\"0\",
      \"fluorescence\":
        {
          \"color\":\"Yellow\",
          \"intensity\":\"Medium\"
        },
      \"feedListingId\":\"07888a8a-f5fa-02bf-a8b2-38a5370609d4\",
      \"ownStock\":false,
      \"girdlePct\":4.0,
      \"girdleCondition\":\"\",
      \"eyeClean\":\"\",
      \"culetCondition\":\"\",
      \"culetSize\":\"N\",
      \"city\": \"\",
      \"state\": \"\",
      \"country\":
      \"India\",
      \"rapNetDiamondId\":154246266
      }";
        let replace_text = Text.replace(response_text, #text "\"type\"", "\"diamondMediaType\"");
        let blob = JSON.fromText(replace_text, null);

        switch (blob) {
            case (#err(msg)) {
                #err("Failed to decode JSON " #msg);
            };
            case (#ok(blob)) {
                let response : ?DiamondTypes.Data = from_candid (blob);
                #ok(response);
            };
        };

    };

};
