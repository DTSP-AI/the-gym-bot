# Dockerfile
FROM python:3.11-slim

# Create non-root user
RUN adduser --disabled-password --gecos '' appuser
USER appuser
WORKDIR /home/appuser/app

# Set up venv & install deps
RUN python -m venv venv
ENV PATH="/home/appuser/app/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app sources
COPY src/ src/

EXPOSE 8000

# Start FastAPI from src/app.py
CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8000"]
