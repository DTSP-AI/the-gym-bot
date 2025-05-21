# Use minimal Python base image
FROM python:3.11-slim

# Create non-root user for security
RUN adduser --disabled-password --gecos '' appuser

# Set working directory inside container
WORKDIR /app
USER appuser

# Set up Python virtual environment
ENV VIRTUAL_ENV=/home/appuser/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy pip requirements (from your root dir)
COPY requirements.txt .

# Install dependencies inside the venv
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire `src/` directory into container at `/app/src/`
COPY src/ src/

# Expose FastAPI default port
EXPOSE 8000

# Start FastAPI from `src/app.py` using `app` instance
CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8000"]
