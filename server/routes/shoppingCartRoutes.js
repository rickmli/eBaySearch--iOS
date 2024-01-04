// Import your controller or functions that handle MongoDB operations
const express = require("express");
const shoppingCartController = require("../controllers/shoppingCartController");

// Define your routes using the Express Router
const router = express.Router();

router
  .route("/")
  .get(shoppingCartController.getAllItems) // Assuming getAllItems is a defined
  .delete(shoppingCartController.removeDataFromShoppingCart) // Assuming
  .post(shoppingCartController.addDataToShoppingCart);

router.route("/deleteAll").delete(shoppingCartController.deleteAllItems);
//removeDataFromShoppingCart is a defined function in your shoppingCartController

module.exports = router;
