# Dockerfile
FROM python:3.11-slim

# 1) System-level deps (if you need any OS packages)
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     build-essential \
#     && rm -rf /var/lib/apt/lists/*

# 2) Copy & install Python deps as root (puts console scripts into /usr/local/bin)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3) Create a non-root user
RUN adduser --disabled-password --gecos '' appuser

# 4) Switch to non-root user
USER appuser
WORKDIR /home/appuser/app

# 5) Copy application code
COPY src/ src/

# 6) Expose the port that Render (or Docker) will map
EXPOSE 8000

# 7) Use explicit python -m invocation—no reliance on PATH at all
ENTRYPOINT ["python", "-m", "uvicorn"]
CMD ["src.app:app", "--host", "0.0.0.0", "--port", "${PORT:-8000}"]
