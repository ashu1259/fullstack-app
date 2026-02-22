const express = require("express");
const axios = require("axios");
const bodyParser = require("body-parser");

const app = express();
app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.render("index", { response: null });
});

app.post("/submit", async (req, res) => {
  const { name, email } = req.body;

  try {
    const response = await axios.post(
  "http://flask-backend-service:5000/process",
  { name, email }
);

    res.render("index", { response: response.data.message });
  } catch (error) {
    res.render("index", { response: "Error connecting to backend" });
  }
});

app.listen(3000, () => {
  console.log("Frontend running on port 3000");
});
