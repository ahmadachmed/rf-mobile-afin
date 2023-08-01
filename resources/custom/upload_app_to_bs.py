import os
import requests
from robot.api.deco import keyword

@keyword("UPLOAD APP")
def uploadApp(userName,password,appName):
    url = "https://api-cloud.browserstack.com/app-automate/upload"
    payload = {'custom_id': 'SampleApp'}
    f = open('apps/'+ appName, 'rb')
    files={"file": f}

    resp = requests.post(url, auth=(userName,password), data=payload, files=files).json()
    app_url = resp["app_url"]
    # os.environ["BS_APP_URL"] = app_url
    return app_url
    # print("app url: " + app_url)


