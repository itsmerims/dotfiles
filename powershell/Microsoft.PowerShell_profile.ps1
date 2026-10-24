# --- Simple Aliases ---
Set-Alias ll Get-ChildItem
Set-Alias c clear

# --- Functions (For commands with arguments) ---
function gst { git status }
function fg { flutter pub get }
function fclean { flutter clean }
function fd { flutter devices }
function gcm { git commit -m $args }
function dcu { docker-compose up -d }
function dev { cd C:\Users\Administrator\dev }
function ..   { cd .. }
function agyd { agy --dangerously-skip-permissions $args }
function go-serbi {
    cd "$HOME/dev/serbify-client-app"  # Adjust path prefix if it's not in your user home folder
    agy --dangerously-skip-permissions $args
}
function sclient { cd C:\Users\Administrator\dev\serbify-client-app }
function sapi { cd C:\Users\Administrator\dev\serbify-api }
function spro { cd C:\Users\Administrator\dev\serbify-pro-app }
function build-apk { flutter build apk --release --target-platform android-arm64 }
function Connect-Android {
    <#
    .SYNOPSIS
        Pairs and/or connects an Android device to ADB wirelessly.
    #>
    [CmdletBinding()]
    param()

    # 1. Get the IP Address
    $ip = Read-Host "Enter Android IP Address (e.g., 192.168.1.5)"
    if ([string]::IsNullOrWhiteSpace($ip)) {
        Write-Warning "IP Address cannot be empty."
        return
    }

    # 2. Ask if pairing is needed
    $pairChoice = Read-Host "Do you need to PAIR the device first? (y/N)"
    
    if ($pairChoice -eq 'y' -or $pairChoice -eq 'yes') {
        # Get pairing port and code from "Pair device with pairing code" screen
        $pairPort = Read-Host "Enter PAIRING Port Number"
        $pairCode = Read-Host "Enter 6-digit PAIRING Code"
        
        if ([string]::IsNullOrWhiteSpace($pairPort) -or [string]::IsNullOrWhiteSpace($pairCode)) {
            Write-Warning "Pairing port and code cannot be empty."
            return
        }

        Write-Host "Pairing with ${ip}:${pairPort}..." -ForegroundColor Cyan
        # Pipe the pairing code into the adb pair command automatically
        $pairCode | adb pair "${ip}:${pairPort}"
        
        Write-Host "Pairing step finished. Look at your phone's main Wireless Debugging screen for the connecting port." -ForegroundColor Yellow
    }

    # 3. Get the Connection Port (Main screen port)
    $connectPort = Read-Host "Enter the main CONNECTION Port Number"
    if ([string]::IsNullOrWhiteSpace($connectPort)) {
        Write-Warning "Connection Port Number cannot be empty."
        return
    }

    Write-Host "Attempting to connect to ${ip}:${connectPort}..." -ForegroundColor Cyan
    
    # Execute the final connection
    adb connect "${ip}:${connectPort}"
}
function frun { flutter run --no-pub }
function home-debug {
    <#
    .SYNOPSIS
        Connects an Android device to ADB wirelessly using hardcoded defaults or parameters.
    #>
    [CmdletBinding()]
    param(
        [string]$IP = "192.168.1.32",       # Put your default phone IP here
        [switch]$Pair                     # Add -Pair only if you need to do a first-time pairing
    )

    # Automatically prompt for the active wireless debugging port
    $Port = Read-Host "Enter Wireless Debugging PORT"

    if ([string]::IsNullOrWhiteSpace($Port)) {
        Write-Warning "Connection port cannot be empty."
        return
    }

    if ($Pair) {
        # Fallback to manual input only when pairing is explicitly requested
        $pairPort = Read-Host "Enter PAIRING Port Number"
        $pairCode = Read-Host "Enter 6-digit PAIRING Code"
        
        if ([string]::IsNullOrWhiteSpace($pairPort) -or [string]::IsNullOrWhiteSpace($pairCode)) {
            Write-Warning "Pairing port and code cannot be empty."
            return
        }

        Write-Host "Pairing with ${IP}:${pairPort}..." -ForegroundColor Cyan
        $pairCode | adb pair "${IP}:${pairPort}"
        Write-Host "Pairing finished. Proceeding to connect..." -ForegroundColor Yellow
    }

    Write-Host "Attempting to connect to ${IP}:${Port}..." -ForegroundColor Cyan
    
    # Execute the final connection
    adb connect "${IP}:${Port}"
}
function dorm-debug {
    <#
    .SYNOPSIS
        Connects an Android device to ADB wirelessly using hardcoded defaults or parameters.
    #>
    [CmdletBinding()]
    param(
        [string]$IP = "192.168.1.93",       # Put your default phone IP here
        [switch]$Pair                     # Add -Pair only if you need to do a first-time pairing
    )

    # Automatically prompt for the active wireless debugging port
    $Port = Read-Host "Enter Wireless Debugging PORT"

    if ([string]::IsNullOrWhiteSpace($Port)) {
        Write-Warning "Connection port cannot be empty."
        return
    }

    if ($Pair) {
        # Fallback to manual input only when pairing is explicitly requested
        $pairPort = Read-Host "Enter PAIRING Port Number"
        $pairCode = Read-Host "Enter 6-digit PAIRING Code"
        
        if ([string]::IsNullOrWhiteSpace($pairPort) -or [string]::IsNullOrWhiteSpace($pairCode)) {
            Write-Warning "Pairing port and code cannot be empty."
            return
        }

        Write-Host "Pairing with ${IP}:${pairPort}..." -ForegroundColor Cyan
        $pairCode | adb pair "${IP}:${pairPort}"
        Write-Host "Pairing finished. Proceeding to connect..." -ForegroundColor Yellow
    }

    Write-Host "Attempting to connect to ${IP}:${Port}..." -ForegroundColor Cyan
    
    # Execute the final connection
    adb connect "${IP}:${Port}"
}
function sha-1 { cd android; .\gradlew signingReport }
