# ---- Stage 1: Scraping with Node.js + Alpine ----
    FROM node:18-alpine AS scraper

    # Install necessary packages for Chromium to work with Puppeteer
    RUN apk add --no-cache \
          chromium \
          nss \
          freetype \
          harfbuzz \
          ca-certificates \
          ttf-freefont \
          bash \
          curl
    
    # Set environment variable to skip Puppeteer's bundled Chromium and use the system-installed one
    ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
        PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
    
    # Set working directory inside the container
    WORKDIR /app
    
    # Copy package.json and install Node.js dependencies
    COPY package.json ./
    RUN npm install
    
    # Copy the scraping script to the container
    COPY scrape.js ./
    
    # Set a default URL (can be overridden at build time)
    ENV SCRAPE_URL=https://example.com
    
    # Run the scraping script and generate scraped data
    RUN node scrape.js
    
    # ---- Stage 2: Serving with Python ----
    FROM python:3.11-slim
    
    # Set working directory for the Python container
    WORKDIR /app
    
    # Copy the scraped data from the Node.js stage
    COPY --from=scraper /app/scraped_data.json ./
    
    # Copy the server.py (Flask application) and requirements.txt to the Python container
    COPY server.py ./
    COPY requirements.txt ./
    
    # Install Python dependencies from requirements.txt
    RUN pip install --no-cache-dir -r requirements.txt
    
    # Expose port 5000 to the host machine
    EXPOSE 5000
    
    # Start the Flask application when the container runs
    CMD ["python", "server.py"]
    