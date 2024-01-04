const express = require("express");
const eBayController = require("../controllers/eBayController");

const router = express.Router();

// router.param("id", tourController.checkID);

router.route("/advanceSearch").get(eBayController.advanceSearch);
router.route("/getSingleItem").get(eBayController.getSingleItem);
router.route("/getSimilarItems").get(eBayController.getSimilarItems);
// router.route("/").get(autoCompleteController.sayHi);

module.exports = router;
