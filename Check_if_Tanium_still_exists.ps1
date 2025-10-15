# Function to uninstall a program using the provided uninstall string
function Uninstall-Program {
    param (
        [string]$uninstallString,
        [string]$silentParameter
    )

    if (-not [string]::IsNullOrWhiteSpace($uninstallString)) {
        $process = Start-Process -FilePath $uninstallString -ArgumentList $silentParameter -PassThru
        $process.WaitForExit()
    }
}


# Check if the Tanium folder exists
$folderPathLog = "C:\Program Files (x86)\Tanium\Tanium Client\Logs"
$folderExistsLog = Test-Path -Path $folderPath
$folderPath = "C:\Program Files (x86)\Tanium\Tanium Client\"
$folderExists = Test-Path -Path $folderPath

if ($folderExists -or $folderExistsLog) {
    Write-Host 'Check if the Tanium service exists'
    $serviceStatus = Get-Service -Name "Tanium Client" -ErrorAction SilentlyContinue
    $serviceExist = $serviceStatus -ne $null
    Write-Host "$serviceExist"
}

if ($serviceExist) {
    Write-Host 'Service Exists'
    Stop-Service -Name "TaniumDriverSvc" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "Tanium Client" -Force -ErrorAction SilentlyContinue
    #Start-Process -FilePath "C:\Program Files (x86)\Tanium\Tanium Client\uninst.exe" -ArgumentList "/S"
    #Start-Sleep -Seconds 30  # Adjust the time as needed

    # Uninstall Tanium Client with /silent
    $taniumUninstallString = Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -match "Tanium Client" } | Select-Object -ExpandProperty UninstallString
    Uninstall-Program -uninstallString $taniumUninstallString -silentParameter '/silent'

    Start-Sleep -Seconds 30

    # Remove Puppet Agent (assuming you have its uninstall string) with /qn /norestart
    $puppetUninstallString = Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -match "Puppet Agent" } | Select-Object -ExpandProperty UninstallString
    Uninstall-Program -uninstallString $puppetUninstallString -silentParameter '/qn /norestart'
    
}
elseif (!$serviceExist) {
    Write-Host 'Remove Service'
    Stop-Service -Name "TaniumDriverSvc" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "Tanium Client" -Force -ErrorAction SilentlyContinue
    $service = Get-WmiObject -Class Win32_Service -Filter "Name='Tanium Client'" -ErrorAction SilentlyContinue
    $service.delete() 
    $service = Get-WmiObject -Class Win32_Service -Filter "Name='TaniumDriverSvc'" -ErrorAction SilentlyContinue
    $service.delete() 

    # Remove Tanium folder
    Remove-Item -Path "C:\Program Files (x86)\Tanium\" -Recurse -Force -ErrorAction SilentlyContinue

    # Remove shortcut
    $shortcutPath = "c:\Users\Public\Desktop\Self Service Client.lnk"
    if (Test-Path -Path $shortcutPath) {
        Remove-Item -Path $shortcutPath -Force -ErrorAction SilentlyContinue
    } 
}
Remove-Variable serviceExist, folderExists -ErrorAction SilentlyContinue

# C:\Program Files\Puppet Labs\Puppet\pxp-agent# Check if the Tanium folder exists
$folderPath = "C:\Program Files (x86)\Tanium"
$folderExists = Test-Path -Path $folderPath
$folderPathLog = "C:\Program Files (x86)\Tanium\Tanium Client\Logs"
$folderExistsLog = Test-Path -Path $folderPath

# Check if the Tanium service is running
$serviceStatus = Get-Service -Name "Tanium Client" -ErrorAction SilentlyContinue

# Check if Desktop Icon still exist
$desktopicon = Test-Path "C:\Users\Public\Desktop\Self Service Client.lnk"

# Check compliance status
if ($folderExists -or $folderExistsLog -or $serviceStatus -or $desktopicon) {
    Return "Non-Compliant"
}
else {
    Return "Compliant"
}


# Function to uninstall a program using the provided uninstall string
function Uninstall-Program {
    param (
        [string]$uninstallString,
        [string]$silentParameter
    )

    if (-not [string]::IsNullOrWhiteSpace($uninstallString)) {
        $process = Start-Process -FilePath $uninstallString -ArgumentList $silentParameter -PassThru
        $process.WaitForExit()
    }
}

# Check if the Tanium service exists
$serviceStatus = Get-Service -Name "Tanium Client" -ErrorAction SilentlyContinue
$serviceExists = $serviceStatus -ne $null

# Check if the Tanium folder exists
$folderPath = "C:\Program Files (x86)\Tanium"
$folderExists = Test-Path -Path $folderPath

if ($serviceExists) {
    S#tart-Process -NoNewWindow -FilePath "C:\Program Files (x86)\Tanium\Tanium Client" -ArgumentList "/slient"
    Start-Sleep -Seconds 60  # Adjust the time as needed

    # Remove Puppet Agent (assuming you have its uninstall string) with /qn /norestart
    $puppetUninstallString = Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -match "Puppet Agent" } | Select-Object -ExpandProperty UninstallString
    #Uninstall-Program -uninstallString $puppetUninstallString -silentParameter '/qn /norestart'
    
    $serviceStatus = Get-Service -Name "Tanium Client" -ErrorAction SilentlyContinue
    $serviceExists = $serviceStatus -ne $null

    if ($serviceExists) {
        # Uninstall Tanium Client with /silent
        $taniumUninstallString = Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -match "Tanium Client" } | Select-Object -ExpandProperty UninstallString
        #Uninstall-Program -uninstallString $taniumUninstallString -silentParameter '/silent'
    }
    else {
        Write-Host "Non-Compliant"
    }

}
elseif (!$serviceExists) {
    # Remove Tanium folder
    Remove-Item -Path $folderPath -Recurse -Force -ErrorAction SilentlyContinue

    # Remove shortcut
    $shortcutPath = "c:\Users\Public\Desktop\Self Service Client.lnk"
    if (Test-Path -Path $shortcutPath) {
        Remove-Item -Path $shortcutPath -Force -ErrorAction SilentlyContinue
    } 
}