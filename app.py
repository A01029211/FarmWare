# app.py (Flask)
from flask import Flask, send_file, abort
import psycopg2
import io

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        host="db",
        database="farmware_db",
        user="farmware_user",
        password="farmware_passwordsupersecreto"
    )
    return conn

@app.route('/images/<filename>')
def get_image(filename):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT image_data FROM images WHERE filename=%s", (filename,))
    result = cur.fetchone()
    cur.close()
    conn.close()

    if result is None:
        abort(404)
    else:
        # result[0] es el BYTEA de la imagen
        return send_file(io.BytesIO(result[0]), mimetype='image/jpeg')
