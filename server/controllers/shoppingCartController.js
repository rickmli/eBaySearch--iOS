const mongoose = require("mongoose");

const schema = new mongoose.Schema(
  {
    id: {
      type: String,
      required: true,
      unique: true,
    },
    image: String,
    title: String,
    price: String,
    shippingCost: String,
    zipcode: String,
    condition: String,
  },
  { strict: false }
);

const shoppingCart = mongoose.model("shoppingCart", schema, "favorites");
schema.index({ id: 1 }, { unique: true });

// Function to remove data from the shoppingCart collection
exports.removeDataFromShoppingCart = async function (req, res) {
  try {
    const { query } = req;
    const { id } = query;
    const filter = {
      id: id,
    };
    const result = await shoppingCart.deleteOne(filter);
    console.log(`${result.deletedCount} document(s) deleted`);
    res.status(200).json({
      status: "success",
      requestedAt: req.requestTime,
      results: result.deletedCount,
    });
  } catch (error) {
    // console.error("Error removing data:", error);
    // res.status(500).json({
    //   status: "error",
    //   message: "Error removing data",
    //   error: error.toString(),
    // });
    res.status(500).json([]);
  }
};

// Function to add data to the shoppingCart collection
exports.addDataToShoppingCart = async function (req, res) {
  console.log("reached!");
  try {
    console.log(req.body);
    const { id, image, title, price, shippingCost, zipcode, condition } =
      req.body;

    console.log(req.body);
    // Create a new shoppingCart item
    const newItem = new shoppingCart({
      id, // Use itemId consistently
      image,
      title,
      price,
      shippingCost,
      zipcode,
      condition,
    });
    console.log(newItem);
    schema.index({ itemId: 1 }, { unique: true });
    // Save the new item to the shoppingCart collection
    const savedItem = await newItem.save();
    res.status(200).json({
      status: "success",
      data: savedItem,
    });
  } catch (error) {
    if (error.code === 11000) {
      // Duplicate key error
      console.error("Duplicate key error:", error);
      res.status(400).json({
        status: "error",
        message: "Duplicate key error",
      });
    } else {
      console.error("Error adding data:", error);
      res.status(500).json({
        status: "error",
        message: "Error adding data",
        error: error.toString(),
      });
    }
  }
};

// Function to retrieve all items from the shoppingCart collection
exports.getAllItems = async function (req, res) {
  try {
    const items = await shoppingCart.find({}).exec();
    console.log(items);
    res.status(200).json(items);
  } catch (error) {
    console.error("Error retrieving items:", error);
    // res.status(500).json({
    //   status: "error",
    //   message: "Error retrieving items",
    //   error: error.toString(),
    // });
    res.status(500).json([]);
  }
};

exports.deleteAllItems = async function (req, res) {
  try {
    const result = await shoppingCart.deleteMany();
    console.log(`${result.deletedCount} document(s) deleted`);
    res.status(200).json({
      status: "success",
      requestedAt: req.requestTime,
      results: result.deletedCount,
    });
  } catch (error) {
    console.error("Error removing data:", error);
    res.status(500).json({
      status: "error",
      message: "Error removing data",
      error: error.toString(),
    });
  }
};
