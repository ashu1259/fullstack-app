const express = require("express");
const bodyParser = require("body-parser");
const axios = require("axios");

const app = express();
app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({ extended: true }));

// Docker service name
const BACKEND_URL = "http://backend:5000/process";

app.get("/", (req, res) => {
  res.render("index", { response: null });
});

app.post("/submit", async (req, res) => {
  try {
    const response = await axios.post(BACKEND_URL, {
      name: req.body.name,
      email: req.body.email,
    });

    res.render("index", { response: response.data.message });
  } catch (error) {
    res.render("index", { response: "Error connecting to backend" });
  }
});

app.listen(3000, "0.0.0.0", () => {
  console.log("Frontend running on port 3000");
});