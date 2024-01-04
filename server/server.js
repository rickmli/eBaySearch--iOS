const mongoose = require("mongoose");
const app = require("./app");
// Create a MongoClient with a MongoClientOptions object to set the Stable API version

app.get("/", (req, res) => {
  res.send("Hello from server");
});

function startApp() {
  const port = process.env.PORT || 8080;

  app.listen(port, () => {
    console.log(`App running on port ${port}...`);
  });
}
// Connect to the database at application startup
async function connectToDB() {
  try {
    const DB =
      "mongodb+srv://rmli:asTWVk5OYseE8yww@ebaysearchfavorites--io.ltahig6.mongodb.net/?retryWrites=true&w=majority";
    await mongoose
      .connect(DB, {
        useNewUrlParser: true,
      })
      .then(() => console.log("DB connection successful!"));

    // Start the application only after successful DB connection
    startApp();
  } catch (error) {
    console.error("Failed to connect to the database:", error);
  }
}

// Call the function to connect to the database
connectToDB();
