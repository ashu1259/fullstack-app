const express = require("express");
const axios = require("axios");
const bodyParser = require("body-parser");

const app = express();
app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({ extended: true }));

// VERY IMPORTANT: Use docker-compose service name
const BACKEND_URL = "http://backend:5000/process";

app.get("/", (req, res) => {
  res.render("index", { response: null });
});

app.post("/submit", async (req, res) => {
  const { name, email } = req.body;

  try {
    const response = await axios.post(BACKEND_URL, {
      name,
      email,
    });

    res.render("index", { response: response.data.message });
  } catch (error) {
    console.error("Backend Error:", error.message);
    res.render("index", { response: "Error connecting to backend" });
  }
});

app.listen(3000, "0.0.0.0", () => {
  console.log("Frontend running on port 3000");
});