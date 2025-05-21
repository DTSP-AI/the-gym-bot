# Dockerfile

# ─── Use a specific, lightweight Python runtime ───────────────────────────────────
# Using a specific tag like 'slim-buster' provides a stable base
# and a smaller image size compared to just 'slim'.
FROM python:3.11-slim-buster

# Set the working directory in the container
WORKDIR /src

# Copy the requirements.txt file into the container
COPY ../requirements.txt /src/

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application files into the container
COPY .. /src/

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["python", "app.py"]