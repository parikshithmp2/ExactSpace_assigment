# Web Scraping and Hosting with Node.js and Python (Dockerized)

This project demonstrates how to scrape data from a given URL using Puppeteer (Node.js), and then serve the scraped data using a Python Flask web server. The entire application is containerized using Docker, enabling easy deployment and scalability.

### Technologies Used:
- **Node.js**: For web scraping using Puppeteer.
- **Puppeteer**: A Node.js library for headless browser automation and web scraping.
- **Flask**: A Python web framework to serve the scraped content.
- **Docker**: For containerization, creating a multi-stage build.

### Prerequisites:
Before running the project, ensure you have the following tools installed:
- **Docker**: To build and run the container.
- **A web browser**: To access the Flask server and view the scraped data.

### Building the Docker Image:
To build the Docker image and scrape a webpage, follow these steps:

1. Clone the repository to your local machine:
   
   git clone https://github.com/parikshithmp2/ExactSpace_assigment.git

2. Build the Docker image. You can specify the URL to scrape by passing the --build-arg flag:

   docker build --build-arg SCRAPE_URL=https://example.com -t puppeteer-flask .

3. Running the Docker Container:
   
   docker run -p 5000:5000 puppeteer-flask
   Your Flask web server will be accessible at http://localhost:5000. Open this URL in your browser to see the scraped data in JSON format.

# File Structure:

puppeteer-flask/
│
├── Dockerfile               # Multi-stage Dockerfile to build the image
├── requirements.txt         # Python dependencies (Flask)
├── server.py                # Python Flask app to serve the scraped data
├── scrape.js                # Node.js script using Puppeteer to scrape the web
├── package.json             # Node.js dependencies (Puppeteer, etc.)
├── scraped_data.json        # Generated JSON file from the scraping script
└── README.md                # This documentation file
