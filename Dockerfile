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

# ─── Set a default PORT environment variable ───────────────────────────────────
# This ensures a numeric value is always available for uvicorn.
# Render or docker-compose can still override this if they set PORT.
ENV PORT=8000

# ─── Define the command to run the application ─────────────────────────────────
# Using the exec form of ENTRYPOINT is generally preferred for clarity and
# ensures environment variables like ${PORT} are expanded directly by Docker.
ENTRYPOINT ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "${PORT}"]