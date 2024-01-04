const fetchComplete = async function (urlLink) {
  try {
    const res = await fetch(urlLink, { method: "GET" });
    const data = await res.json();
    return data;
  } catch (err) {
    throw new Error(`Fetch error: ${err}`);
  }
};

exports.getZipcode = async (req, res) => {
  try {
    const { query } = req;
    // if (!query.prefix) throw new Error("No prefix detected!");
    const postalPrefix = query.prefix;
    const maxRow = query.maxRow || 5;
    const urlLink = `http://api.geonames.org/postalCodeSearchJSON?postalcode_startsWith=${postalPrefix}&maxRows=${maxRow}&username=rickmli&country=US`;
    let { postalCodes } = await fetchComplete(urlLink);
    postalCodes = postalCodes.map((postalCode) => postalCode.postalCode);

    res.status(200).json(postalCodes);
  } catch (error) {
    res.status(500).json([]);
  }
};

// exports.sayHi = (req, res) => {
//   console.log(req);
//   console.log("Hello from node");
//   res.status(200).json({
//     status: "success",
//     requestedAt: req.requestTime,
//     results: 1,
//     data: "hello!",
//   });
// };
