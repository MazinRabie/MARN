import httpx

url = "http://127.0.0.1:8000/api/v1/chat"
payload = {"sessionId": "c16d8c0a-8616-4bfd-a81f-0a9842bddd2d"}

try:
    response = httpx.post(url, json=payload)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")
except Exception as e:
    print(f"Error: {e}")
