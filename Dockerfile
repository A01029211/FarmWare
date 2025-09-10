# Usa una imagen oficial de Python
FROM python:3.13-slim

# Carpeta de trabajo
WORKDIR /app

# Copia todos los archivos de tu proyecto
COPY . .

# Instala dependencias
RUN pip install --no-cache-dir Flask psycopg2-binary

# Expone el puerto donde Flask corre
EXPOSE 3001

# Comando para correr la app
CMD ["python", "app.py"]
