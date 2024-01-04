const express = require("express");
const morgan = require("morgan");
const cors = require("cors");

const autoCompleteRouter = require("./routes/autoCompleteRoutes");
const eBayRouter = require("./routes/eBayRoutes");
const googleRouter = require("./routes/googleRoutes");
const shoppingCartRouter = require("./routes/shoppingCartRoutes");

const app = express();
// 1) MIDDLEWARES
app.use(morgan("dev"));

app.use(express.json());
app.use(cors());
app.use(express.static(`${__dirname}/client/dist`));

// console.log(__dirname);
app.use((req, res, next) => {
  // console.log("Hello from the middleware 👋");
  next();
});

app.use((req, res, next) => {
  req.requestTime = new Date().toISOString();
  next();
});

// 3) ROUTES
app.use("/autoComplete", autoCompleteRouter);
app.use("/eBay", eBayRouter);
app.use("/google", googleRouter);
app.use("/shoppingCart", shoppingCartRouter);

module.exports = app;
