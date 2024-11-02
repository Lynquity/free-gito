import requests
import random
import json
import os
import subprocess
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity

DIR = "C:\Windows\System32\ELW\gito"
# Datei zur Speicherung der Commit-Nachrichten
COMMIT_FILE = "C:\Windows\System32\ELW\gito\commit_messages.json"

if not os.path.exists(DIR):
    os.makedirs(DIR)


# Funktion zum Abrufen der letzten 40 Commits aus einem Standard-Repository
def fetch_commit_messages():
    url = "https://api.github.com/repos/torvalds/linux/commits"  # Beliebiges öffentliches Repository
    params = {"per_page": 40}
    response = requests.get(url, params=params)
    
    if response.status_code == 200:
        commits = response.json()
        messages = [commit['commit']['message'] for commit in commits]
        return messages[:40]  # Maximal 40 Nachrichten
    else:
        print("Fehler beim Abrufen der Commits:", response.json())
        return []

# Funktion zum Laden der Commit-Nachrichten aus einer Datei oder Abrufen von GitHub
def load_or_fetch_commit_messages():
    if os.path.exists(COMMIT_FILE):
        with open(COMMIT_FILE, "r") as f:
            commit_messages = json.load(f)
        print("Commit-Nachrichten aus lokaler Datei geladen.")
    else:
        commit_messages = fetch_commit_messages()
        with open(COMMIT_FILE, "w") as f:
            json.dump(commit_messages, f)
        print("Commit-Nachrichten von GitHub abgerufen und gespeichert.")
    return commit_messages

# Initialisierung: Commit-Nachrichten laden und Vektorisierer erstellen
commit_messages = load_or_fetch_commit_messages()
vectorizer = CountVectorizer().fit(commit_messages)
commit_vectors = vectorizer.transform(commit_messages)

# Funktion zur Erzeugung einer ähnlichen Commit-Nachricht
def generate_similar_commit(input_text):
    input_vector = vectorizer.transform([input_text])
    similarities = cosine_similarity(input_vector, commit_vectors).flatten()
    
    # Finde die ähnlichste Nachricht und gebe sie zurück
    most_similar_index = np.argmax(similarities)
    similar_commit = commit_messages[most_similar_index]
    
    # Variation hinzufügen
    variations = ["Fix", "Update", "Improve", "Add", "Refactor", "Remove"]
    new_commit = similar_commit.replace(
        similar_commit.split()[0], random.choice(variations), 1
    )
    
    return new_commit

# Funktion, um geänderte Dateien abzurufen
def get_changed_files():
    try:
        # Abrufen der Liste geänderter Dateien
        result = subprocess.run(["git", "status", "--porcelain"], capture_output=True, text=True, check=True)
        files = [line[3:] for line in result.stdout.splitlines() if line]
        return files
    except subprocess.CalledProcessError as e:
        print("Fehler beim Abrufen geänderter Dateien:", e.stderr)
        return []

# Möglichkeit zur Bearbeitung der Nachricht
def edit_commit_message(suggested_commit, changed_files):
    # Fügt die Liste der geänderten Dateien zur vorgeschlagenen Nachricht hinzu
    files_list = "\n".join(f"- {file}" for file in changed_files)
    enhanced_commit = f"{suggested_commit}\n\nGeänderte Dateien:\n{files_list}"
    
    print("\nVorgeschlagene Nachricht inklusive geänderter Dateien:")
    print(f"> {enhanced_commit}")
    print("Bearbeite die Nachricht direkt hier oder drücke Enter, um sie zu akzeptieren:")
    
    # Benutzer kann die Nachricht bearbeiten
    edited_commit = input("> ").strip()
    
    # Wenn der Benutzer nur Enter drückt, behalten wir die Originalnachricht
    return edited_commit if edited_commit else enhanced_commit

# Funktion zum Hinzufügen einer neuen Nachricht zur Liste
def update_commit_messages(new_commit):
    global commit_messages, vectorizer, commit_vectors
    if len(commit_messages) >= 40:
        commit_messages.pop(0)  # Entferne die älteste Nachricht
    commit_messages.append(new_commit)
    
    # Aktualisiere den Vektorisierer und die Vektoren
    vectorizer = CountVectorizer().fit(commit_messages)
    commit_vectors = vectorizer.transform(commit_messages)
    
    # Speichern der aktualisierten Liste in der Datei
    with open(COMMIT_FILE, "w") as f:
        json.dump(commit_messages, f)

# Funktion zum Ausführen eines Git-Commits mit der Nachricht
def git_commit(message):
    try:
        # Füge alle Änderungen hinzu, einschließlich neuer Dateien
        subprocess.run(["git", "add", "-A"], check=True)
        
        # Commit mit Nachricht erstellen
        result = subprocess.run(["git", "commit", "-m", message], check=True, capture_output=True, text=True)
        print("Commit erfolgreich erstellt:", result.stdout)
    except subprocess.CalledProcessError as e:
        print("Fehler beim Erstellen des Commits:", e.stderr)

# Generiere und bearbeite eine Commit-Nachricht
input_text = "Fix bug in search function"
suggested_commit = generate_similar_commit(input_text)

# Abrufen der geänderten Dateien
changed_files = get_changed_files()

# Erzeuge die endgültige Commit-Nachricht mit Dateiinformationen
final_commit = edit_commit_message(suggested_commit, changed_files)
print("Endgültige Commit-Nachricht:", final_commit)

# Füge die neue Commit-Nachricht zur Liste hinzu und aktualisiere
update_commit_messages(final_commit)

# Bestätige und führe den Commit aus
confirm = input("Möchtest du diese Nachricht verwenden und committen? (ja/nein): ").strip().lower()
if confirm == "ja":
    git_commit(final_commit)
else:
    print("Commit wurde abgebrochen.")
