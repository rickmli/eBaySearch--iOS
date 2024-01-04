exports.getRelatedImages = async (req, res) => {
  try {
    const { query } = req;

    const { keyword, imageSize = "huge", num = 8 } = query;
    // AIzaSyDR3UeWzdxC57RK7f90oBpqLp65MiBkZeg
    const key = "AIzaSyAkXrQa0otSp0ie-bOJJoGk_XgUtgIfPe4";
    const URL = `https://www.googleapis.com/customsearch/v1?q=${keyword}&cx=523013c51484a40c0&imgSize=${imageSize}&num=${num}&searchType=image&key=${key}`;
    const response = await fetch(URL, { method: "GET" });
    const data = await response.json();
    // console.log(data);
    const images = data.items.map((imageInfo) => imageInfo.link);
    res.status(200).json(images);
  } catch (err) {
    // res.status(404).json({
    //   status: "fail",
    //   requestedAt: req.requestTime,
    //   err: err,
    // });
    res.status(500).json([]);
  }
};
