$ErrorActionPreference = "SilentlyContinue"
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   WINDOWS 10 DEBLOAT & GUNCELLEME KILITLEME BASLIYOR...        " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 0. Tarayicisiz kalmamak ve CyberChef'i acabilmek icin Firefox kontrolu
Write-Host "`n[1/5] Alternatif tarayici olarak Mozilla Firefox kontrol ediliyor/kuruluyor..." -ForegroundColor Yellow
if (-not (Test-Path "$env:ProgramFiles\Mozilla Firefox\firefox.exe")) {
    winget install -e --id Mozilla.Firefox --accept-source-agreements --accept-package-agreements --silent
}

# 1. Copilot, Microsoft Store, Hava Durumu (Weather), Bing ve diger gereksiz UWP paketlerini komple sil
Write-Host "`n[2/5] Copilot, Microsoft Store, Hava Durumu ve Bing uygulamalari siliniyor..." -ForegroundColor Yellow
$bloatApps = @(
    "*Copilot*",
    "*Microsoft.WindowsStore*",
    "*Microsoft.StorePurchaseApp*",
    "*Microsoft.BingWeather*",
    "*Microsoft.BingNews*",
    "*Microsoft.BingFinance*",
    "*Microsoft.BingSports*",
    "*Microsoft.BingSearch*",
    "*Microsoft.BingTranslator*",
    "*Microsoft.GetHelp*",
    "*Microsoft.Getstarted*",
    "*Microsoft.MicrosoftSolitaireCollection*",
    "*Microsoft.People*",
    "*Microsoft.WindowsFeedbackHub*",
    "*Microsoft.Xbox*",
    "*Microsoft.ZuneMusic*",
    "*Microsoft.ZuneVideo*",
    "*Microsoft.YourPhone*"
)

foreach ($app in $bloatApps) {
    Get-AppxPackage -AllUsers $app | Remove-AppxPackage -AllUsers
    Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $app } | Remove-AppxProvisionedPackage -Online | Out-Null
}

# Copilot, Gorev Cubugu Hava Durumu (News and Interests) ve Baslat Menusu Bing Web Aramasini Kapatma
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Value 1 -Type DWord
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Value 1 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton" -Value 0 -Type DWord

# Gorev cubugundaki Hava Durumu / Haberler widget'ini tamamen kapat
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Value 0 -Type DWord
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2 -Type DWord

# Baslat menusunde bir sey ararken Bing sonuclarinin cikmasini engelle
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Value 0 -Type DWord

# Microsoft Store'u grup ilkesiyle de tamamen kilitle
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Name "RemoveWindowsStore" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Name "AutoDownload" -Value 2 -Type DWord

# 2. Microsoft Edge'i Komple Kaldirma
Write-Host "`n[3/5] Microsoft Edge ve arka plan servisleri komple siliniyor..." -ForegroundColor Yellow
Stop-Process -Name "msedge" -Force
Stop-Process -Name "MicrosoftEdgeUpdate" -Force

New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdateDev" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdateDev" -Name "AllowUninstall" -Value 1 -Type DWord
Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" -Name "NoRemove"

$edgeSetups = Get-ChildItem -Path "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\*\Installer\setup.exe"
foreach ($setup in $edgeSetups) {
    Start-Process -FilePath $setup.FullName -ArgumentList "--uninstall --system-level --verbose-logging --force-uninstall" -Wait
}

Get-AppxPackage -AllUsers *Microsoft.MicrosoftEdge* | Remove-AppxPackage -AllUsers
Get-ScheduledTask | Where-Object { $_.TaskName -like "*MicrosoftEdge*" } | Unregister-ScheduledTask -Confirm:$false
Stop-Service -Name "edgeupdate" -Force
Stop-Service -Name "edgeupdatem" -Force
sc.exe delete edgeupdate | Out-Null
sc.exe delete edgeupdatem | Out-Null

takeown /F "${env:ProgramFiles(x86)}\Microsoft\Edge" /R /D Y | Out-Null
icacls "${env:ProgramFiles(x86)}\Microsoft\Edge" /grant administrators:F /T | Out-Null
Remove-Item -Path "${env:ProgramFiles(x86)}\Microsoft\Edge" -Recurse -Force
Remove-Item -Path "${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate" -Recurse -Force
Remove-Item -Path "$env:Public\Desktop\Microsoft Edge.lnk" -Force
Remove-Item -Path "$env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Force
Remove-Item -Path "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk" -Force

New-Item -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate" -Name "DoNotUpdateToEdgeWithChromium" -Value 1 -Type DWord

# 3. Windows Update'i KALICI OLARAK Tamamen Devre Disi Birakma (WaaSMedicSvc dahil!)
Write-Host "`n[4/5] Windows Update servisleri ve zamanlanmis gorevleri kalici olarak kilitleniyor..." -ForegroundColor Yellow
$updateServices = @("wuauserv", "UsoSvc", "WaaSMedicSvc", "DoSvc", "BITS")
foreach ($svc in $updateServices) {
    Stop-Service -Name $svc -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc" -Name "Start" -Value 4 -Type DWord
}

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Force | Out-Null
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "DisableOSUpgrade" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "DoNotConnectToWindowsUpdateInternetLocations" -Value 1 -Type DWord

# Windows Update Zamanlanmis Gorevlerini Devre Disi Birak
Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\*" | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\*" | Disable-ScheduledTask | Out-Null

# 4. Masaustunu ve SPICE Kopyala-Yapistir Servisini Yenile
Write-Host "`n[5/5] Masaustu ve SPICE Kopyala-Yapistir servisi yenileniyor..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 2
Start-Process explorer.exe
Start-Sleep -Seconds 2
net stop vdservice 2>$null
net start vdservice 2>$null

Write-Host "`n================================================================" -ForegroundColor Green
Write-Host " ISLEM TAMAMLANDI!                                              " -ForegroundColor Green
Write-Host " - Copilot, Edge, Store, Hava Durumu ve Bing tamamen silindi.   " -ForegroundColor Green
Write-Host " - Windows Update (WaaSMedic dahil) kalici olarak kapatildi.    " -ForegroundColor Green
Write-Host " - Alternatif tarayici olarak Firefox kuruldu.                  " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
pause
