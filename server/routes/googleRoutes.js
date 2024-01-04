const express = require("express");
const googleController = require("../controllers/googleController");

const router = express.Router();
router.route("/customSearch").get(googleController.getRelatedImages);

module.exports = router;
