import subprocess

def get_staged_files():
    result = subprocess.run(
        ['git', 'status', '--porcelain'],
        capture_output=True,
        text=True
    )
    lines = result.stdout.strip().split('\n')
    files = []
    for line in lines:
        if line:
            status = line[:2].strip()
            rest = line[3:].strip()
            files.append((status, rest))
    return files

def generate_commit_message(files):
    messages = []
    for status, path in files:
        if status == 'A':
            messages.append(f"Hinzugefügt --> {path}")
        elif status == 'M':
            messages.append(f"Geändert --> {path}")
        elif status == 'D':
            messages.append(f"Gelöscht --> {path}")
        elif status.startswith('R'):
            if ' -> ' in path:
                old_path, new_path = path.split(' -> ')
                messages.append(f"Verschoben/Umbenannt --> {old_path} zu {new_path}")
            else:
                messages.append(f"Verschoben/Umbenannt --> {path}")
        else:
            messages.append(f"{status} --> {path}")
    return ' '.join(messages)

def main():
    files = get_staged_files()
    if not files:
        print("Keine gestagten Änderungen gefunden.")
        return
    commit_message = generate_commit_message(files)
    print("Generierte Commit-Nachricht:")
    print(commit_message)

    user = input('Drücken Sie "c", um zu committen: ')
    if user.lower() == 'c':
        print("Führe Git Commit aus...")
        try:
            # Commit-Befehl ausführen
            result = subprocess.run(
                ['git', 'commit', '-m', commit_message],
                check=True,
                capture_output=True,
                text=True
            )
            print("Commit erfolgreich!")
            print(result.stdout)
        except subprocess.CalledProcessError as e:
            print(f"Fehler beim Commit: {e}")
            print("Fehlermeldung:", e.stderr)
    else:
        print("Commit abgebrochen.")

if __name__ == "__main__":
    main()
