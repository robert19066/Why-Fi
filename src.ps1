Clear-Host
# Get all Wi-Fi profiles
$wifiProfiles = @(netsh wlan show profiles | Where-Object { $_ -match "All User Profile" } | ForEach-Object {
    ($_ -split ":")[1].Trim()
})

# Display the array of Wi-Fi profiles
Write-Host "Saved Wi-Fi Profiles:" -ForegroundColor Green
$wifiProfiles | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }

# Ask user to select a Wi-Fi profile
$usr_input = Read-Host "Please type the name of the Wi-Fi profile you want to get the password for:" 

# Check if the user input matches any Wi-Fi profile
if ($wifiProfiles -contains $usr_input) {
    # Retrieve the Wi-Fi password for the selected profile
    $result = netsh wlan show profile name="$usr_input" key=clear
    $password = $result | Select-String -Pattern "Key Content" | ForEach-Object { ($_ -split ":")[1].Trim() }
    
    # Get Wi-Fi signal strength for the currently connected network
    $signalStrength = (netsh wlan show interfaces | Select-String -Pattern "Signal" | ForEach-Object { ($_ -split ":")[1].Trim() }).Trim("%")
    
    if ($password) {
        Write-Host "Password for '$usr_input': $password" -ForegroundColor Cyan
        Write-Host "Signal Strength: $signalStrength%" -ForegroundColor Cyan
    } else {
        Write-Host "Password not found for the selected profile. It may not be stored on this system." -ForegroundColor Red
    }
} else {
    Write-Host "The Wi-Fi profile '$usr_input' does not exist. Please check the name and try again." -ForegroundColor Red
}
