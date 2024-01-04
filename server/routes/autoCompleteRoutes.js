const express = require("express");
const autoCompleteController = require("../controllers/autoCompleteController");

const router = express.Router();

// router.param("id", tourController.checkID);

router.route("/").get(autoCompleteController.getZipcode);
// router.route("/").get(autoCompleteController.sayHi);

module.exports = router;
