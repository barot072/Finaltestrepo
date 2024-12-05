# Use the official lightweight Python image
FROM python:3.9-slim
 
# Set working directory in the container
WORKDIR /app
 
# Copy dependency file first for efficient caching of layers
COPY requirements.txt .
 
# Install Python dependencies and system-level packages
RUN pip install --no-cache-dir -r requirements.txt && \
    apt-get update && apt-get install -y --no-install-recommends supervisor && \
    mkdir -p /var/log/supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
 
# Copy application code and Supervisor configuration
COPY app.py .
COPY supervisord.conf .
 
# Expose the port the Flask app will run on
EXPOSE 5000
 
# Use Supervisor to manage the Flask app
CMD ["/usr/bin/supervisord", "-c", "/app/supervisord.conf"]