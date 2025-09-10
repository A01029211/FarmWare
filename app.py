# app.py (Flask) - Versión corregida
from flask import Flask, send_file, abort
import psycopg2
import io
import mimetypes

app = Flask(__name__)

def get_db_connection():
    """Conecta a PostgreSQL"""
    return psycopg2.connect(
        host="localhost",  # Cambiar si tu BD está en otra máquina
        database="farmware_db",
        user="farmware_user",
        password="farmware_passwordsupersecreto"
    )

@app.route('/images/<path:filename>')
def get_image(filename):
    """Devuelve la imagen desde la base de datos"""
    filename = filename.strip()  # elimina espacios accidentales
    
    conn = None
    cur = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT image_data FROM images WHERE filename ILIKE %s", (filename,))
        result = cur.fetchone()
    except psycopg2.OperationalError as e:
        # Si no se conecta a la BD
        print("Error de conexión:", e)
        abort(500, description="Error al conectar con la base de datos")
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

    if result is None:
        abort(404, description="Imagen no encontrada")

    # Detecta el tipo de imagen automáticamente
    mime_type, _ = mimetypes.guess_type(filename)
    if mime_type is None:
        mime_type = 'application/octet-stream'

    return send_file(io.BytesIO(result[0]), mimetype=mime_type)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3001, debug=True)
