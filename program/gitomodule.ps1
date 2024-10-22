param (
    [string]$message
)

function gito ($paramether) {
    try {        
        git add *
        
        git commit -m $paramether
        
        git push
    
        Write-Host "Git gepusht"
    }
    catch {
        Write-Error "
        Git error"
    }
}