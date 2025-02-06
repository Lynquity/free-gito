import http.client
import json
import subprocess

dif = ""

subprocess.run(['git', 'add', '.'], capture_output=True, text=True)


def get_git_diff():
    """Get the staged git diff (i.e. changes to be committed)."""
    result = subprocess.run(['git', 'diff', '--cached'], capture_output=True, text=True)
    return result.stdout

dif = get_git_diff()

conn = http.client.HTTPSConnection("mamiksik-commit-message-generator.hf.space")
payload = json.dumps({
  "data": [
    f"{dif}",
    40,
    5,
    7,
    1
  ]
})
headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer <HF_TOKEN>'
}
conn.request("POST", "/run/predict", payload, headers)
res = conn.getresponse()
data = res.read()
decoded_data = data.decode("utf-8")
result = json.loads(decoded_data)  

commit_message = result["data"][2]["label"]

print("Commit Message:", commit_message)

confirmation = input("\nDo you want to commit with this message? [c]: ").strip().lower()
if confirmation == 'c':
    subprocess.run(["git", "commit", "-m", commit_message])
    print("Commit created!")
else:
    print("Commit aborted.")
