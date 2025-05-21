# Dockerfile
FROM python:3.11-slim

# Create non-root user
RUN adduser --disabled-password --gecos '' appuser
USER appuser
WORKDIR /home/appuser/app

# Set up venv & install deps
RUN python -m venv venv
COPY requirements.txt .
RUN ./venv/bin/pip install --no-cache-dir -r requirements.txt

# Copy app sources (includes src/prompts/prompt.json)
COPY src/ src/

# Let runtime define port via $PORT
ENV PORT=8000

EXPOSE 8000

# Use venv's python explicitly
CMD ["./venv/bin/uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "$PORT"]
