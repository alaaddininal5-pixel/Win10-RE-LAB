$ErrorActionPreference = "SilentlyContinue"
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   TERSINE MUHENDISLIK LAB - WINDOWS SISTEM AYARLARI YAPILIYOR  " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Dosya Gezgini (File Explorer) Analiz Ayarlari
Write-Host "`n[1/7] Dosya Gezgini: Dosya uzantilari, gizli ve sistem dosyalari aciliyo..." -ForegroundColor Yellow
$advKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $advKey -Name "HideFileExt" -Value 0 -Type DWord          # Bilinen dosya uzantilarini goster (.exe, .dll gizlenmesin)
Set-ItemProperty -Path $advKey -Name "Hidden" -Value 1 -Type DWord               # Gizli dosyalari goster
Set-ItemProperty -Path $advKey -Name "ShowSuperHidden" -Value 1 -Type DWord      # Korunan isletim sistemi dosyalarini goster (+s +h zararli dosyalari icin)
Set-ItemProperty -Path $advKey -Name "LaunchTo" -Value 1 -Type DWord             # Dosya Gezginini Hizli Erisim yerine "Bu Bilgisayar" ile ac
Set-ItemProperty -Path $advKey -Name "FullPath" -Value 1 -Type DWord             # Baslik cubugunda tam dosya yolunu goster
Set-ItemProperty -Path $advKey -Name "TaskbarAnimations" -Value 0 -Type DWord    # Performans icin gorev cubugu animasyonlarini kapat

# Koyu Tema (Dark Mode - Göz yorgunlugunu azaltmak icin)
$themeKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
Set-ItemProperty -Path $themeKey -Name "AppsUseLightTheme" -Value 0 -Type DWord
Set-ItemProperty -Path $themeKey -Name "SystemUsesLightTheme" -Value 0 -Type DWord

# 2. Windows Defender, SmartScreen ve Bulut Gonderimini Kalici Kapatma (OPSEC)
Write-Host "[2/7] Defender, SmartScreen ve Buluta Ornek Gonderimi (Sample Submission) kapatiliyor..." -ForegroundColor Yellow
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force | Out-Null
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Force | Out-Null
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Force | Out-Null

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableIOAVProtection" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScriptScanning" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Value 2 -Type DWord # Asla ornek gonderme
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -Value 0 -Type DWord

# C:\ surucusunu Defender dislamalarina (Exclusion) ekle
Add-MpPreference -ExclusionPath "C:\" -ErrorAction SilentlyContinue
Set-MpPreference -SubmitSamplesConsent NeverSend -MAPSReporting Disabled -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue

# SmartScreen Kapatma ("Windows kişisel bilgisayarınızı korudu" mavi uyarisini kaldirir)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Type String
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Value 0 -Type DWord
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" -Name "EnabledV9" -Value 0 -Type DWord

# 3. Windows Hata Raporlama (WerFault) ve Telemetri Kapatma
Write-Host "[3/7] Windows Hata Raporlama (WerFault) ve Telemetri kapatiliyor (Debugger cokuslerini hizlandirir)..." -ForegroundColor Yellow
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "DontShowUI" -Value 1 -Type DWord
Stop-Service -Name "WerSvc" -Force
Set-Service -Name "WerSvc" -StartupType Disabled

# Telemetri servisini kapat
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord
Stop-Service -Name "DiagTrack" -Force
Set-Service -Name "DiagTrack" -StartupType Disabled

# 4. Windows Update Otomatik Yeniden Baslatma ve Guncellemeleri Durdurma
Write-Host "[4/7] Windows Update otomatik guncelleme ve yeniden baslatmalar kapatiliyor..." -ForegroundColor Yellow
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord
Stop-Service -Name "wuauserv" -Force
Set-Service -Name "wuauserv" -StartupType Disabled

# 5. Guc ve Uyku Ayarlari (Analiz sirasinda ekran kapanmasin / uykuya gecmesin)
Write-Host "[5/7] Uyku modu ve ekran kapatma suresi 'Hicbir Zaman' olarak ayarlaniyor..." -ForegroundColor Yellow
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /hibernate off

# 6. Ortam Degiskenleri (PATH ve Microsoft Symbol Server _NT_SYMBOL_PATH)
Write-Host "[6/7] Microsoft Symbol Server (_NT_SYMBOL_PATH) ve RE araclari PATH'e ekleniyor..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "C:\Symbols" | Out-Null
[System.Environment]::SetEnvironmentVariable("_NT_SYMBOL_PATH", "srv*C:\Symbols*https://msdl.microsoft.com/download/symbols", "Machine")

$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$extraPaths = @("C:\RE_Tools\FLOSS", "C:\RE_Tools\CAPA", "C:\RE_Tools\Apktool")
foreach ($p in $extraPaths) {
    if ((Test-Path $p) -and ($currentPath -notlike "*$p*")) {
        $currentPath += ";$p"
    }
}
[System.Environment]::SetEnvironmentVariable("Path", $currentPath, "Machine")

# 7. Sag Tik Menusu (Context Menu) Entegrasyonlari (.exe ve .dll dosyalari icin!)
Write-Host "[7/7] Sag Tik Menusune (Detect It Easy, x64dbg, x32dbg, PE-bear, ImHex) kisayollari ekleniyor..." -ForegroundColor Yellow
$searchPaths = @(
    "C:\RE_Tools",
    "$env:LOCALAPPDATA\Microsoft\WinGet\Packages",
    "$env:LOCALAPPDATA\Programs",
    "$env:ProgramFiles",
    "${env:ProgramFiles(x86)}"
)

function Add-RightClickTool($menuName, $exeFilter) {
    $found = Get-ChildItem -Path $searchPaths -Filter $exeFilter -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $regPath = "Registry::HKEY_CLASSES_ROOT\*\shell\$menuName"
        $cmdPath = "$regPath\command"
        New-Item -Path $regPath -Force | Out-Null
        Set-ItemProperty -Path $regPath -Name "(Default)" -Value $menuName
        Set-ItemProperty -Path $regPath -Name "Icon" -Value "`"$($found.FullName)`""
        New-Item -Path $cmdPath -Force | Out-Null
        Set-ItemProperty -Path $cmdPath -Name "(Default)" -Value "`"$($found.FullName)`" `"%1`""
        Write-Host "   [+] Sag Tik eklendi: $menuName" -ForegroundColor Green
    }
}

Add-RightClickTool "1. Detect It Easy (DIE) ile Analiz Et" "die.exe"
Add-RightClickTool "2. PE-bear ile Incele" "PE-bear.exe"
Add-RightClickTool "3. x64dbg (64-bit) ile Debug Et" "x64dbg.exe"
Add-RightClickTool "4. x32dbg (32-bit) ile Debug Et" "x32dbg.exe"
Add-RightClickTool "5. ImHex ile Hex Incele" "imhex.exe"
Add-RightClickTool "6. JADX-GUI ile Ac (APK/JAR)" "jadx-gui.exe"

# Explorer'i yeniden baslat ki uzantilar ve koyu tema aninda aktif olsun
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Start-Process explorer.exe

Write-Host "`n================================================================" -ForegroundColor Green
Write-Host " TUM WINDOWS REVERSE ENGINEERING LAB AYARLARI TAMAMLANDI!       " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
pause
