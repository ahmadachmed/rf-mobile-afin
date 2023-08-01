import os
import requests

import requests

class SlackChatHistory:
    def __init__(self):
        self.oauth_access_token = os.environ.get("SLACK_TOKEN")
        self.api_url = "https://slack.com/api/conversations.history"

    def get_chat_history(self, channel_or_group_id, limit=3):
        api_url = f"{self.api_url}?channel={channel_or_group_id}&limit={limit}"

        # Menambahkan Authorization header dengan OAuth Access Token
        headers = {
            "Authorization": f"Bearer {self.oauth_access_token}"
        }

        # Permintaan GET ke API Slack untuk mendapatkan riwayat percakapan
        response = requests.get(api_url, headers=headers)

        # Parsing respons JSON
        if response.status_code == 200:
            data = response.json()
            if data["ok"]:
                return data["messages"]
            else:
                print("Permintaan gagal:", data["error"])
        else:
            print("Gagal menghubungi API Slack.")

        return None

class GetMessage:
    def get_message_by_phone_number(self, target_phone_number):
            target_messages = []
            req = SlackChatHistory()
            response_data = req.get_chat_history(os.environ.get("SLACK_SMS_CHANNEL"), limit=3)
            for message in response_data:
                if 'text' in message and 'To: ' in message['text']:
                    phone_number = message['text'].split('To: ')[1].split('\n')[0]
                    if phone_number == target_phone_number:
                        target_messages.append(message['text'])
            return target_messages