from flask import Flask, request, jsonify

app = Flask(__name__)
orders = []

@app.route("/orders", methods=["GET"])
def get_orders():
    return jsonify(orders)

@app.route("/orders", methods=["POST"])
def add_order():
    data = request.json
    orders.append(data)
    return jsonify({"message": "Order added"}), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
