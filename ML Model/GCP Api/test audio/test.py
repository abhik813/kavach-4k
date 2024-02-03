import requests

with open('test audio/normal174.mp3', "rb") as file:
    audio_content = file.read()

# resp = requests.post("http://127.0.0.1:5000/", files={'file': open('test audio/normal172.mp3', 'rb')})
resp = requests.post("https://getprediction-d72eydv5ca-et.a.run.app/", files={'file': audio_content})


print(resp.status_code)
if resp.status_code != 204:
      print(resp.json())
else: print(resp.status_code)