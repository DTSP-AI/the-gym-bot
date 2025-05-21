# Dockerfile
FROM python:3.11-slim

# Create non-root user
RUN adduser --disabled-password --gecos '' appuser
USER appuser
WORKDIR /home/appuser/app

# Install venv & deps
RUN python -m venv venv
ENV PATH="/home/appuser/app/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source & prompts
COPY src/ src/
COPY .env .
# no need to copy .venv

EXPOSE 8000

# Launch the FastAPI app
CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8000"]
