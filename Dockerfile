# Use a lightweight base image
FROM python:3.11-slim

# Set working directory to /app
WORKDIR /app

# Copy dependency list and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all remaining files (including app/)
COPY . .

# Open app port
EXPOSE 8000

# Start FastAPI — referencing app inside /app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
