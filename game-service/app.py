from flask import Flask, request, jsonify

app = Flask(__name__)
games = []

@app.route("/games", methods=["GET"])
def get_games():
    return jsonify(games)

@app.route("/games", methods=["POST"])
def add_game():
    data = request.json
    games.append(data)
    return jsonify({"message": "Game added"}), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
