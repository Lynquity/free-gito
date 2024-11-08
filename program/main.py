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
            status, filename = line.split('\t', 1)
            files.append((status, filename))
    return files

def generate_commit_message(files):
    messages = []
    for status, filename in files:
        if status == 'A':
            messages.append(f"Hinzugefügt --> {filename}")
        elif status == 'M':
            messages.append(f"Geändert --> {filename}")
        elif status == 'D':
            messages.append(f"Gelöscht --> {filename}")
        else:
            messages.append(f"{status} --> {filename}")
    return '\n'.join(messages)

def main():
    files = get_staged_files()
    if not files:
        print("Keine gestagten Änderungen gefunden.")
        return
    commit_message = generate_commit_message(files)
    print("Generierte Commit-Nachricht:")
    print(commit_message)

    user = input('c to commit')
    if user.capitalize() == 'C':
        result = subprocess.run(
            ['git', 'commit', '-m', commit_message],
            check=True,
            capture_output=True,
            text=True
        )

    print('Commit done')

 

if __name__ == "__main__":
    main()
