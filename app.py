from flask import Flask, jsonify, send_file
import psycopg2
from io import BytesIO

app = Flask(__name__)

# Configuración de la base de datos
DB_HOST = "db"  # si usas docker-compose y tu servicio se llama db
DB_NAME = "farmware_db"
DB_USER = "farmware_user"
DB_PASS = "farmware_passwordsupersecreto"

def get_db_connection():
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )
    return conn

@app.route("/images/<filename>")
def get_image(filename):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT image_data FROM images WHERE filename = %s", (filename,))
    row = cur.fetchone()
    cur.close()
    conn.close()

    if row is None:
        return jsonify({"error": "Image not found"}), 404

    image_bytes = row[0]
    return send_file(BytesIO(image_bytes), mimetype="image/jpeg", download_name=filename)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3001)
