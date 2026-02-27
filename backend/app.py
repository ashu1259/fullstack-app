from flask import Flask, request, jsonify
import os

app = Flask(__name__)

@app.route("/process", methods=["POST"])
def process():
    data = request.get_json()
    name = data.get("name")
    email = data.get("email")

    message = f"Received Name: {name}, Email: {email}"
    return jsonify({"message": message})

@app.route("/health")
def health():
    return jsonify({"status": "Backend Running"})


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)