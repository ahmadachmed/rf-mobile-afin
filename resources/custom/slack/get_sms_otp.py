from robot.api.deco import keyword
import re
from get_message import GetMessage

@keyword("Get otp in slack by phone")
def get_sms_otp(phone_number):
    otp = []
    get_message = GetMessage()
    msg = get_message.get_message_by_phone_number(phone_number)
    for message in msg:
        code_match = re.search(r'\b\d{6}\b', message)
        if code_match:
            otp.append(code_match.group())
    return otp[0]


