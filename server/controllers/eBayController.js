const { search } = require("../app");
const oauthToken = require("../ebay_oauth_token");

const appId = "RickLi-csci570-PRD-af6fbf322-38e64f8a";
// const clientSecret = "PRD-f6fbf322889d-a562-415f-818d-1098";

const fetchAdvanceSearch = async function (URL) {
  try {
    const res = await fetch(URL, { method: "GET" });
    const data = await res.json();

    return data.findItemsAdvancedResponse[0].searchResult[0];
  } catch (err) {
    throw new Error(`Fetch error: ${err}`);
  }
};

const fetchSingleItem = async function (URL, accessToken) {
  try {
    const res = await fetch(URL, {
      method: "GET",
      headers: { "X-EBAY-API-IAF-TOKEN": accessToken },
    });
    const data = await res.json();
    return data.Item;
  } catch (err) {
    throw new Error(`Fetch error: ${err}`);
  }
};

const fetchSimilarItems = async function (URL) {
  try {
    const res = await fetch(URL, { method: "GET" });
    const data = await res.json();

    return data.getSimilarItemsResponse.itemRecommendations.item;
  } catch (err) {
    throw new Error(`Fetch error: ${err}`);
  }
};

exports.getSimilarItems = async (req, res) => {
  try {
    const { query } = req;

    const { itemId, maxResults = 20 } = query;
    const URL = `https://svcs.ebay.com/MerchandisingService?OPERATION-NAME=getSimilarItems&SERVICE-NAME=MerchandisingService&SERVICE-VERSION=1.1.0&CONSUMER-ID=${appId}&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&itemId=${itemId}&maxResults=${maxResults}`;
    var searchResult = await fetchSimilarItems(URL);
    searchResult = searchResult.map((item) => {
      const id = item?.itemId ?? "";
      // ● Image of the product
      const image = item?.imageURL ?? "";
      // ● Title of the product
      const title = item?.title ?? "";
      // ● Price of the product
      const price = item?.buyItNowPrice?.__value__ ?? "";
      // ● Shipping cost of the product
      const shippingCost = item?.shippingCost?.__value__ ?? "";
      // ● Days Left
      const timeLeft = item?.timeLeft ?? "";
      const daysLeft = timeLeft.match(/P(.*?)D/)?.[1] ?? "";
      return {
        id,
        image,
        title,
        price,
        shippingCost,
        daysLeft,
      };
    });

    res.status(200).json(searchResult);
  } catch (err) {
    // res.status(404).json({
    //   status: "fail",
    //   requestedAt: req.requestTime,
    //   err: err,
    // });
    res.status(500).json([]);
  }
};

exports.getSingleItem = async (req, res) => {
  try {
    const { query } = req;
    // console.log(query);
    const { itemId } = query;
    const URL = `https://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=${appId}&siteid=0&version=967&ItemID=${itemId}&IncludeSelector=Description,Details,ItemSpecifics`;

    const accessToken = await oauthToken.getApplicationToken();
    const searchResult = await fetchSingleItem(URL, accessToken);
    console.log(searchResult);
    const id = searchResult?.ItemID ?? "N/A";
    // ● Images of the product
    const images = searchResult?.PictureURL ?? [];
    // ● Url of the product
    const url = searchResult?.ViewItemURLForNaturalSearch ?? "";
    // ● Title of the product
    const title = searchResult?.Title ?? "N/A";
    // ● Price of the product
    const price = searchResult?.CurrentPrice?.Value ?? "N/A";
    // ● Specifics of the product
    let descriptions = searchResult?.ItemSpecifics?.NameValueList;
    const transformedDescriptions = descriptions.map(({ Name, Value }) => {
      return {
        name: Name,
        value: Value[0],
      };
    });

    // ● Store Name: Hyperlink with the name of the store name linked to the storeURL from the ‘StoreName’ and ‘StoreURL’ attributes of ‘Storefront’ property of Item.
    const storeName = searchResult?.Storefront?.StoreName ?? "";
    const storeURL = searchResult?.Storefront?.StoreURL ?? "";
    // ● Popularity: ‘PositiveFeedbackPercent’ of the ‘Seller’ attribute.
    const popularity = searchResult?.Seller?.PositiveFeedbackPercent ?? "";
    // ● Feedback Score: ‘FeedbackScore’ of the ‘Seller’ attribute.
    const feedbackScore = searchResult?.Seller?.FeedbackScore ?? "";

    // ● Shipping Cost: ‘FREE’ if cost is 0.
    const shippingCost = "0" ?? "";
    // ● Global Shipping: ‘GlobalShipping’ property of the ‘Item’: ‘Yes’ if the value is ‘True’ and ‘No’ if ‘False’.
    const isGlobalShipping = searchResult?.GlobalShipping ? "Yes" : "No";
    // ● Handling Time: ‘HandlingTime’ property of the ‘Item’.
    const handlingTime = searchResult?.HandlingTime ?? "";
    // ● Policy: ‘ReturnsAccepted’ attribute of ‘ReturnPolicy’ key of the ‘Item’.
    const policy = searchResult?.ReturnPolicy?.ReturnsAccepted ?? "";
    // ● Refund Mode: ‘Refund’ attribute of ‘ReturnPolicy’ key of the ‘Item’.
    const refundMode = searchResult?.ReturnPolicy?.Refund ?? "";
    // ● Return Within: ‘ReturnsWithin’ attribute of ‘ReturnPolicy’ key of the ‘Item’.
    const returnsWithin = searchResult?.ReturnPolicy?.ReturnsWithin ?? "";
    // ● Shipping Cost Paid By: ‘ShippingCostPaidBy’ attribute of ‘ReturnPolicy’ key of the ‘Item’
    const shippingCostPaidBy =
      searchResult?.ReturnPolicy?.ShippingCostPaidBy ?? "";

    res.status(200).json({
      id,
      images,
      url,
      title,
      price: String(price),
      descriptions: transformedDescriptions,
      storeName,
      storeURL,
      popularity: String(popularity),
      feedbackScore: String(feedbackScore),
      shippingCost,
      isGlobalShipping,
      handlingTime: String(handlingTime),
      policy,
      refundMode,
      returnsWithin,
      shippingCostPaidBy,
    });
  } catch (err) {
    // res.status(404).json({
    //   status: "fail",
    //   requestedAt: req.requestTime,
    //   err: err,
    // });
    res.status(500).json([]);
  }
};

exports.advanceSearch = async (req, res) => {
  try {
    const { query } = req;

    const {
      keywords,
      numEntries = 50,
      page = 1,
      postalCode,
      conditions,
      shippingOptions,
      maxDistance = 10,
      categoryId,
    } = query;

    let URL =
      "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD";

    URL += `&SECURITY-APPNAME=${appId}`;
    URL += `&keywords=${keywords}`;
    URL += `&paginationInput.entriesPerPage=${numEntries}`;
    URL += `&paginationInput.pageNumber=${page}`;
    if (postalCode) URL += `&buyerPostalCode=${postalCode}`;
    if (categoryId) URL += `&categoryId=${categoryId}`;

    let itemFilterIndex = 0;
    URL += `&itemFilter(${itemFilterIndex}).name=HideDuplicateItems&itemFilter(${itemFilterIndex}).value=true`;
    itemFilterIndex += 1;

    if (maxDistance) {
      URL += `&itemFilter(${itemFilterIndex}).name=MaxDistance`;
      URL += `&itemFilter(${itemFilterIndex}).value=${maxDistance}`;
      itemFilterIndex += 1;
    }
    if (conditions) {
      URL += `&itemFilter(${itemFilterIndex}).name=Condition`;
      let conditionIndex = 0;
      conditions.split(",").map((condition) => {
        URL += `&itemFilter(${itemFilterIndex}).value(${conditionIndex})=${condition}`;
        conditionIndex += 1;
      });
      itemFilterIndex += 1;
    }
    if (shippingOptions) {
      shippingOptions.split(",").map((shippingOption) => {
        URL += `&itemFilter(${itemFilterIndex}).name=${shippingOption}`;
        URL += `&itemFilter(${itemFilterIndex}).value=true`;
        itemFilterIndex += 1;
      });
    }

    URL += `&outputSelector(0)=SellerInfo&outputSelector(0)=SellerInfo`;
    URL += `&outputSelector(1)=StoreInfo&outputSelector(1)=StoreInfo`;
    // console.log(URL);

    const data = await fetchAdvanceSearch(URL);
    var searchResult = data?.item || [];

    searchResult = searchResult.map((item) => {
      const id = item?.itemId[0] ?? "N/A";
      // ● Image of the product
      const image = item?.galleryURL[0] ?? "N/A";
      // ● Title of the product
      const title = item?.title[0] ?? "N/A";
      // ● Price of the product
      const price = item?.sellingStatus[0]?.currentPrice[0]?.__value__ ?? "N/A";
      // ● Shipping cost of the product: If shipping cost is 0, ‘FREE SHIPPING’ should be displayed instead.
      const shippingCost =
        item?.shippingInfo[0]?.shippingServiceCost[0]?.__value__ ?? "N/A";
      // ● Zip code
      const zipcode = item?.postalCode[0] ?? "N/A";
      // ● Condition of the product (New / Used / Refurbished /NA).
      const conditionId = item?.condition?.[0]?.conditionId[0];
      const condition = (function () {
        switch (conditionId) {
          case "1000":
            return "NEW";
          case "2000":
          case "2500":
            return "REFURBISHED";
          case "3000":
          case "4000":
          case "5000":
          case "6000":
            return "USED";

          default:
            return "N/A";
        }
      })();

      return {
        _id: "",
        id,
        image,
        title,
        price,
        shippingCost:
          String(shippingCost) === "0.0" ? "FREE SHIPPING" : shippingCost,
        // shippingCost: shippingCost,
        zipcode,
        condition,
        __v: 0,
      };
    });

    res.status(200).json(searchResult);
  } catch (err) {
    // res.statusCode = 500;
    // res.setHeader("Content-Type", "application/json");
    // res.end(JSON.stringify({ error: err }));
    // throw err;
    res.status(500).json([]);
  }
};
