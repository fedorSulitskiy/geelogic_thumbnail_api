# Use the official Python image as the base
FROM joyzoursky/python-chromedriver:3.7-selenium

# Set the working directory
WORKDIR /

# Copy requirements file separately and install dependencies
RUN pip install Flask \
    && pip install flask_cors \
    && pip install asyncio \
    && pip install gunicorn

# Copy the rest of the application files
COPY . .

# Expose the port your Flask app runs on (replace with your app's port)
EXPOSE 5000

# Define the entry point
CMD ["gunicorn", "-c", "gunicorn_config.py", "main:app"]
