from flask import Flask, send_file, jsonify
from supabase import create_client, Client
from io import BytesIO

app = Flask(__name__)

# --- Configuración Supabase ---
SUPABASE_URL = "https://ldkthvohdsaqqwyyfgir.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxka3Rodm9oZHNhcXF3eXlmZ2lyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1MzkyNDIsImV4cCI6MjA3MzExNTI0Mn0.HbBiNf86dMx2Y3oZq0GntWwQXhQX1s6q7-4O-p-lgmw"


supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Nombre del bucket en Supabase Storage
BUCKET_NAME = "Images"

# --- Rutas ---

# Lista de imágenes disponibles
@app.route("/images", methods=["GET"])
def list_images():
    try:
        response = supabase.storage.from_(BUCKET_NAME).list()
        
        # response es un diccionario con 'data' y 'error'
        if response.get("error"):
            return jsonify({"error": response["error"]["message"]}), 500
        
        image_names = [item["name"] for item in response.get("data", [])]
        return jsonify(image_names)
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Obtener imagen individual
@app.route("/images/<image_name>", methods=["GET"])
def get_image(image_name):
    try:
        response = supabase.storage.from_(BUCKET_NAME).download(image_name)
        
        if response is None:
            return jsonify({"error": "No se pudo descargar el archivo"}), 404
        
        image_bytes = BytesIO(response)
        return send_file(image_bytes, mimetype="image/jpeg", download_name=image_name)
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# --- Ejecutar servidor ---
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000, debug=True)
