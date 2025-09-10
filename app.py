# app.py (Flask)
from flask import Flask, send_file, abort
import psycopg2
import io
import mimetypes

app = Flask(__name__)

def get_db_connection():
    return psycopg2.connect(
        host="db",
        database="farmware_db",
        user="farmware_user",
        password="farmware_passwordsupersecreto"
    )

@app.route('/images/<path:filename>')
def get_image(filename):
    # Elimina espacios o saltos de línea accidentales
    filename = filename.strip()
    
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT image_data FROM images WHERE filename=%s", (filename,))
        result = cur.fetchone()
    finally:
        cur.close()
        conn.close()

    if result is None:
        abort(404)
    
    # Detecta el tipo de imagen automáticamente
    mime_type, _ = mimetypes.guess_type(filename)
    if mime_type is None:
        mime_type = 'application/octet-stream'
    
    return send_file(io.BytesIO(result[0]), mimetype=mime_type)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000, debug=True)
