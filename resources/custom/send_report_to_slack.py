import requests, zipfile, datetime, os
from robot.api import ExecutionResult


ROBOT_LISTENER_API_VERSION = 3

def report(filepath, channelId, token):
    url = "https://slack.com/api/files.upload"
    
    payload = {'channels': channelId}
    files=[
    ('file',(filepath,open(filepath,'rb'),'zip'))
    ]
    headers = {
    "Authorization": token
    }

    response = requests.request("POST", url, headers=headers, data=payload, files=files)

def compressUtil(name):
    # List of files to compress 
    fileReport = "report.html"
    fileLog = "log.html"
    
    files_to_compress = [fileReport, fileLog] 
    
    # Name of the archive file 
    archive_name = name
    
    # Create the archive file 
    with zipfile.ZipFile(archive_name, "w") as archive: 
        for file in files_to_compress: 
            archive.write(file)  

def close():

    #create timestamp
    ct = datetime.datetime.now()
    dateTime = ct.strftime("%Y-%m-%d %H.%M.%S")

    channelId = os.environ.get('slack_channel_id', 'default_value')
    url = os.environ.get('slack_webhook_url', 'default_value')
    token = os.environ.get('slack_token', 'default_value')

    result = ExecutionResult('output.xml')
    result.configure(stat_config={'suite_stat_level': 2,
                                  'tag_stat_combine': 'tagANDanother'})
    stats = result.statistics

    title = '[API Automation Result] - [Go-Core-Topup]'
    passed_tests = stats.total.passed
    failed_tests = stats.total.failed
    skipped_tests = stats.total.skipped
    success_percentage = round( (passed_tests * 100) / (passed_tests + failed_tests), 2)

    templateReport = f'''{{
        "text": "*{title}*",
        "attachments": [
            {{
                "color": "#439FE0",
                "text":  "*Total Passed*: {passed_tests}\\n\\n *Total Failed*: {failed_tests}\\n\\n *Skipped TC*: {skipped_tests}\\n\\n *Success Percentage*: {success_percentage}% \\n\\n ",
                "mrkdwn_in": ["pretext", "text"]
            }}
        ]
    }}'''

    #send sumarry report to slack
    r = requests.post(url=url, data=templateReport)
    
    archive_name = title + " " +dateTime+ ".zip"

    #compress report & log
    compressUtil(archive_name)

    #upload report to slack
    report(archive_name, channelId, token)