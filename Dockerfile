# Use the official slim Python image
FROM python:3.11-slim

# Create a non-root user
RUN adduser --disabled-password --gecos '' appuser

# Set working directory to /app
WORKDIR /app

# Switch to the new user
USER appuser

# Create and activate virtual environment
ENV VIRTUAL_ENV=/home/appuser/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project into the container (includes app/, prompts/, etc.)
COPY . .

# Expose the port your app will run on
EXPOSE 8000

# Run the FastAPI app located in /app/app/app.py
CMD ["uvicorn", "app.app:app", "--host", "0.0.0.0", "--port", "8000"]
