from flask import Flask, jsonify, request, abort

app = Flask(__name__)

# In-memory store
news = [{"id": 0, "title": "Welcome", "content": "First news post"}]
next_id = 1  # simple auto-increment for IDs

@app.route("/", methods=["GET"])
def index():
    return jsonify({
        "endpoints": [
            {"GET": "/"},
            {"GET": "/news"},
            {"POST": "/news"},
            {"PUT": "/news/<id>"},
            {"DELETE": "/news/<id>"}
        ]
    })

# GET /news
@app.route("/news", methods=["GET"])
def list_news():
    return jsonify({"count": len(news), "items": news})

# POST /news
@app.route("/news", methods=["POST"])
def create_news():
    global next_id
    data = request.json
    new_item = {"id": next_id, "title": data.get("title", ""), "content": data.get("content", "")}
    news.append(new_item)
    next_id += 1
    return jsonify(new_item), 201

# PUT /news/<id>
@app.route("/news/<int:item_id>", methods=["PUT"])
def update_news(item_id: int):
    item = next((n for n in news if n["id"] == item_id), None)
    if not item:
        abort(404, description="News not found")
    data = request.json
    for key in ("title", "content"):
        if key in data:
            item[key] = data[key]
    return jsonify(item)

# DELETE /news/<id>
@app.route("/news/<int:item_id>", methods=["DELETE"])
def delete_news(item_id: int):
    global news
    item = next((n for n in news if n["id"] == item_id), None)
    if not item:
        abort(404, description="News not found")
    news = [n for n in news if n["id"] != item_id]
    return jsonify({"status": "deleted", "id": item_id})

if __name__ == "__main__":
    app.run(threaded=True, host="0.0.0.0", port=3001)

