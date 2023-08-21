from flask import Flask, request
from flask_cors import CORS
import asyncio

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.chrome.options import Options;

app = Flask(__name__)
CORS(app)

async def get_screenshot(html_string):
    # Set up options
    chrome_options = Options()
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--window-size=1980,960")
    chrome_options.add_experimental_option("excludeSwitches", ["enable-logging"])
    
    # Initialise selenium driver
    driver = webdriver.Chrome(options=chrome_options)

    # Create a data URI from the HTML code
    data_uri = f"data:text/html;charset=utf-8,{html_string}"

    # Open the web page
    driver.get(data_uri)

    # Wait until map appears
    WebDriverWait(driver, 60).until(
        EC.presence_of_element_located(
            (By.TAG_NAME, "body")
        )
    )

    # Wait until GEE images load on the map
    await asyncio.sleep(10)

    # Get screenshot
    body = driver.find_element(By.TAG_NAME, 'body')
    image = body.screenshot_as_base64
    driver.quit()
    return image

@app.route('/thumbnail_api/get_thumbnail', methods=['POST'])
def get_map_thumbnail():
    html_string = request.form.get('data')

    # Get the screenshot asynchronously
    loop = asyncio.new_event_loop()
    image = loop.run_until_complete(get_screenshot(html_string))
    loop.close()

    return image

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3002)


## ARCHIVE OLD WORKING CODE, NON ASYNC:

# # API mechanism to import the map widget HTML code as string
# @app.route('/get_thumbnail', methods=['POST'])
# def get_map_thumbnail():
#     html_string = request.form.get('data')  
    
#     # Initialise selenium drivers
#     driver = webdriver.Chrome()

#     # Create a data URI from the HTML code
#     data_uri = f"data:text/html;charset=utf-8,{html_string}"

#     # Open the web page
#     driver.get(data_uri)

#     # Wait until map appears
#     WebDriverWait(driver, 60).until(
#         EC.presence_of_element_located(
#             (By.TAG_NAME, "body")
#         )
#     )
    
#     # Wait until GEE images load on map
#     await asyncio.sleep(10)
    
#     # Get screenshot
#     body = driver.find_element(By.TAG_NAME, 'body')
#     image = body.screenshot_as_base64
#     driver.quit()
#     return image