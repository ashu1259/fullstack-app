from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/process", methods=["POST"])
def process():
    data = request.get_json()
    name = data.get("name")
    email = data.get("email")

    message = f"Received Name: {name}, Email: {email}"
    return jsonify({"message": message})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
