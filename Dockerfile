FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PORT=8080

# Initialize database before starting Gunicorn
RUN python -c "from app import app, db; with app.app_context(): db.create_all()"

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app