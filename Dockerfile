FROM python:latest
WORKDIR /app
COPY . .
RUN pip install Flask
EXPOSE 3001
CMD ["python", "app.py"]
