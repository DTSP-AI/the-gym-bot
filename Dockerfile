# Dockerfile
FROM python:3.11-slim

# Create non-root user
RUN adduser --disabled-password --gecos '' appuser
USER appuser
WORKDIR /home/appuser/app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code (including src/prompts/prompt.json)
COPY src/ src/

# Let Render inject PORT at runtime
EXPOSE 8000

# Launch Uvicorn, letting shell expand $PORT
ENTRYPOINT ["sh", "-c"]
CMD ["uvicorn src.app:app --host 0.0.0.0 --port ${PORT:-8000}"]
