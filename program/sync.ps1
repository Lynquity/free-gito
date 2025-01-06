# PowerShell Git Sync Script mit automatischer Branch-Auswahl
$repoPath = ".\"  # Ändere das zu deinem Repo-Pfad

# Wechsle in das Repository-Verzeichnis
Set-Location $repoPath

Write-Host "🔄 Starte Git-Sync für $repoPath" -ForegroundColor Green

# Fetch die neuesten Änderungen
git fetch origin

# Verfügbare Remote-Branches abrufen
$branches = git branch -r | ForEach-Object { $_ -replace 'origin/', '' } | Where-Object { $_ -notmatch "HEAD" }

# Entferne doppelte oder lokale Branches
$branches = $branches | Sort-Object -Unique

# Prüfe, wie viele Branches vorhanden sind
if ($branches.Count -eq 1) {
    $branch = $branches[0]
    Write-Host "✅ Einziger Branch gefunden: $branch"
} else {
    # Benutzer auswählen lassen
    Write-Host "📌 Verfügbare Branches:"
    for ($i = 0; $i -lt $branches.Count; $i++) {
        Write-Host "$($i+1): $($branches[$i])"
    }

    # Auswahl treffen
    $selection = Read-Host "Bitte wähle eine Branch-Nummer"
    $branch = $branches[$selection - 1]
    Write-Host "✅ Gewählter Branch: $branch"
}

# Wechsle zum ausgewählten Branch
git checkout $branch

# Stash lokale Änderungen (falls vorhanden)
git stash push -m "Auto-Stash vor Pull"

# Pull die neuesten Änderungen
$pullOutput = git pull origin $branch 2>&1

# Prüfe auf Merge-Konflikte
if ($pullOutput -match "CONFLICT") {
    Write-Host "⚠ Merge-Konflikt erkannt! Öffne VS Code..." -ForegroundColor Yellow
    code .  # VS Code öffnen
    git status
    exit
}

# Stash-Pop um lokale Änderungen wiederherzustellen
git stash pop

# Prüfe auf neue Änderungen, die committet werden müssen
$status = git status --porcelain
if ($status) {
    Write-Host "📌 Neue Änderungen erkannt, committe und pushe..."
    git add .
    git commit -m "Auto-Sync Update"
    git push origin $branch
} else {
    Write-Host "✅ Keine neuen Änderungen, Repository ist aktuell!"
}

Write-Host "🚀 Git-Sync abgeschlossen!" -ForegroundColor Green
