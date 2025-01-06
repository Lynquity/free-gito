# PowerShell Git Sync Script mit automatischer Branch-Auswahl
$repoPath = "."  # Verwende den aktuellen Ordner oder passe den Pfad an

Write-Host "`n🔄 Starte Git-Sync für $repoPath" -ForegroundColor Green

# Wechsle in das Repository-Verzeichnis
Set-Location $repoPath

# Fetch die neuesten Änderungen
git fetch origin

# Verfügbare Remote-Branches abrufen und formatieren
$branches = git branch -r | ForEach-Object { $_ -replace 'origin/', '' } | Where-Object { $_ -notmatch "HEAD" }

# Entferne doppelte oder lokale Branches
$branches = $branches | Sort-Object -Unique

# Prüfe, wie viele Branches vorhanden sind
if ($branches.Count -eq 1) {
    $branch = $branches[0]
    Write-Host "✅ Einziger Branch gefunden: $branch`n"
}
else {
    # Benutzer auswählen lassen
    Write-Host "📌 Verfügbare Branches:`n"
    for ($i = 0; $i -lt $branches.Count; $i++) {
        Write-Host "$($i+1): $($branches[$i])"
    }

    # Auswahl treffen
    $selection = Read-Host "`nBitte wähle eine Branch-Nummer"
    if ($selection -match '^\d+$' -and [int]$selection -le $branches.Count -and [int]$selection -gt 0) {
        $branch = $branches[$selection - 1]
        Write-Host "`n✅ Gewählter Branch: $branch`n"
    }
    else {
        Write-Host "`n❌ Ungültige Auswahl, Skript wird beendet." -ForegroundColor Red
        exit
    }
}

# Wechsle zum ausgewählten Branch
git checkout $branch

# Stash lokale Änderungen (falls vorhanden)
Write-Host "📦 Lokale Änderungen werden gesichert..."
git stash push -m "Auto-Stash vor Pull"

# Pull die neuesten Änderungen
Write-Host "🔄 Pull von $branch..."
$pullOutput = git pull origin $branch 2>&1

# Prüfe auf Merge-Konflikte
if ($pullOutput -match "CONFLICT") {
    Write-Host "`n⚠ Merge-Konflikt erkannt! Öffne VS Code..." -ForegroundColor Yellow
    code .  # VS Code öffnen
    git status
    exit
}

# Stash-Pop um lokale Änderungen wiederherzustellen
Write-Host "📦 Stash zurückholen..."
git stash pop

# Prüfe auf neue Änderungen, die committet werden müssen
$status = git status --porcelain
if ($status) {
    Write-Host "📌 Neue Änderungen erkannt, committe und pushe..."
    git add .
    git commit -m "Auto-Sync Update"
    git push origin $branch
}
else {
    Write-Host "✅ Keine neuen Änderungen, Repository ist aktuell!"
}

Write-Host "`n🚀 Git-Sync abgeschlossen!" -ForegroundColor Green
