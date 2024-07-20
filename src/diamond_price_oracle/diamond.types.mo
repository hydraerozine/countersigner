module DiamondTypes {
    type DiamondMedia = {
        diamondMediaType : Text;
        url : Text;
    };

    type Color = {
        colorType : Text;
        colorIntensity : Text;
        fancyColor : Text;
        fancyColorOvertone : Text;
        secondaryFancyColor : Text;
        color : Text;
    };

    type GradingReport = {
        lab : Text;
        certificateNumber : Text;
        certificateURL : [Text];
    };

    type Price = {
        totalPrice : Float;
        listingPrice : Float;
        discount : Float;
        pricePerCarat : Float;
        totalPriceInUSD : Float;
    };

    type Measurements = {
        width : Float;
        length : Float;
        height : Float;
    };

    type Fluorescence = {
        color : Text;
        intensity : Text;
    };

    type Pagination = {
        pageNumber : Nat;
        pageSize : Nat;
        totalRecordsFound : Nat;
    };

    type CurrencyResponseModel = {
        currencyID : Nat;
        currencyTitle : Text;
        currencyShortTitle : Text;
        currencySymbol : Text;
        lastRate : Float;
        lastRateInDounble : Float;
        lastUpdate : Text;
    };

    public type Data = {
        id : Nat;
        sellerId : Nat;
        stockNumber : Text;
        diamondMedia : [DiamondMedia];
        shape : Text;
        carat : Float;
        color : Color;
        clarity : Text;
        cut : Text;
        polish : Text;
        symmetry : Text;
        gradingReport : GradingReport;
        price : Price;
        measurements : Measurements;
        depthPct : Float;
        tablePct : Float;
        girdleFrom : Text;
        girdleTo : Text;
        culet : Text;
        fluorescence : Fluorescence;
        feedListingId : Text;
        ownStock : Bool;
        girdlePct : Float;
        girdleCondition : Text;
        eyeClean : Text;
        culetCondition : Text;
        culetSize : Text;
        city : Text;
        state : Text;
        country : Text;
        rapNetDiamondId : Nat;
    };

    public type Response = {
        error : Nat;
        data : [Data];
        pagination : Pagination;
        currencyResponseModel : CurrencyResponseModel;
    };
};
