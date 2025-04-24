
    FROM node:18-alpine AS scraper

    RUN apk add --no-cache \
          chromium \
          nss \
          freetype \
          harfbuzz \
          ca-certificates \
          ttf-freefont \
          bash \
          curl
    

    ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
        PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
    

    WORKDIR /app
    
    # Copy package.json and install Node.js dependencies
    COPY package.json ./
    RUN npm install
    
    # Copy the scraping script to the container
    COPY scrape.js ./
    
    # Set a default URL (can be overridden at build time)
    ENV SCRAPE_URL=https://example.com
    
    RUN node scrape.js
    
    # ---- Stage 2: Serving with Python ----
    FROM python:3.11-slim
    
    WORKDIR /app
    
    COPY --from=scraper /app/scraped_data.json ./

    COPY server.py ./
    COPY requirements.txt ./
    
    RUN pip install --no-cache-dir -r requirements.txt
    
    # Expose port 5000 to the host machine
    EXPOSE 5000
    
    # Start the Flask application when the container runs
    CMD ["python", "server.py"]
    
