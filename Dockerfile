# Use the official Python image as the base
FROM python:3.8

# Adding trusting keys to apt for repositories
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# Adding Google Chrome to the repositories
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Updating apt to see and install Google Chrome
RUN apt-get -y update

# Magic happens
RUN apt-get install -y google-chrome-stable

# # Set environment variables for Chrome and ChromeDriver URLs and versions
# ENV CHROME_URL=https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/116.0.5845.96/linux64/chrome-linux64.zip
# ENV CHROME_VERSION=116.0.5845.96
# ENV CHROMEDRIVER_URL=https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/116.0.5845.96/linux64/chromedriver-linux64.zip
# ENV CHROMEDRIVER_VERSION=116.0.5845.96

# # Install required dependencies
# RUN apt-get update && \
#     apt-get install -y wget unzip && \
#     rm -rf /var/lib/apt/lists/*

# # Download and install Chrome
# RUN wget $CHROME_URL && \
#     unzip chrome-linux64.zip && \
#     rm chrome-linux64.zip && \
#     mv chrome-linux64 /usr/local/bin/ && \
#     ln -s /usr/local/bin/chrome-$CHROME_VERSION /usr/local/bin/chrome

# # Download and install ChromeDriver
# RUN wget $CHROMEDRIVER_URL && \
#     unzip chromedriver-linux64.zip && \
#     rm chromedriver-linux64.zip && \
#     mv chromedriver-linux64 /usr/local/bin/ && \
#     chmod +x /usr/local/bin/chromedriver-linux64

# Set up a working directory
WORKDIR /app

COPY . .

# Install Flask and any other required Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

# Expose the port your Flask app runs on (replace with your app's port)
EXPOSE 5000

# Define the entry point
CMD ["python", "main.py"]
