# Dockerfile

# ─── Use a specific, lightweight Python runtime ───────────────────────────────────
# Using a specific tag like 'slim-buster' provides a stable base
# and a smaller image size compared to just 'slim'.
FROM python:3.11-slim-buster

# ─── Set working directory for the application ───────────────────────────────────
# All subsequent commands will run relative to this directory.
WORKDIR /app

# ─── Install Python dependencies ────────────────────────────────────────────────
# Copy only requirements.txt first to leverage Docker's build cache.
# If requirements.txt doesn't change, this layer won't be rebuilt.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ─── Create a non-root user for security ───────────────────────────────────────
# Running as root inside a container is a security risk.
# 'appuser' is a common convention.
RUN adduser --disabled-password --gecos '' appuser
USER appuser

# ─── Copy application code ─────────────────────────────────────────────────────
# Copy the entire 'src' directory into the working directory of the non-root user.
# This includes app.py and the prompts directory.
COPY src/ ./src/

# ─── Expose the port the application will listen on ────────────────────────────
# This informs Docker that the container listens on the specified network ports at runtime.
EXPOSE 8000

# ─── Define the command to run the application ─────────────────────────────────
# Use the shell form for ENTRYPOINT to allow shell variable expansion (like ${PORT}).
# Uvicorn serves the FastAPI application.
# --host 0.0.0.0 makes the app accessible from outside the container.
# ${PORT:-8000} uses the PORT environment variable if set, otherwise defaults to 8000.
ENTRYPOINT ["sh", "-c", "uvicorn src.app:app --host 0.0.0.0 --port ${PORT:-8000}"]