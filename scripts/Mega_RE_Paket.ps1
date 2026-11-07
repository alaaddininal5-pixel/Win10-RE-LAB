$ErrorActionPreference = "Continue"
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   MEGA TERSINE MUHENDISLIK (RE) LAB KURULUMU BASLIYOR...       " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# Klasor yapilarini olustur
$baseDir = "C:\RE_Tools"
$dlDir   = "C:\RE_Tools\_Downloads"
$deskDir = "$env:USERPROFILE\Desktop\RE_Tools"

$cat1 = "$deskDir\1_Disassembler_ve_Decompiler"
$cat2 = "$deskDir\2_Debugger_Araclari"
$cat3 = "$deskDir\3_APK_ve_Java_Reverse"
$cat4 = "$deskDir\4_PE_ve_Hex_Analiz"
$cat5 = "$deskDir\5_Sistem_Ag_ve_Yardimci"

New-Item -ItemType Directory -Force -Path $baseDir, $dlDir, $deskDir, $cat1, $cat2, $cat3, $cat4, $cat5 | Out-Null

# 1. Winget ile kurulacak araclar
Write-Host "`n[1/4] Winget paketleri kuruluyor (Java JDK 21, Everything, ImHex, Cutter, Android araclari vb.)..." -ForegroundColor Yellow
$wingetPackages = @(
    "EclipseAdoptium.Temurin.21.JDK",
    "voidtools.Everything",
    "WerWolv.ImHex",
    "AngusJohnson.ResourceHacker",
    "Rizin.Cutter",
    "Google.PlatformTools",
    "Microsoft.Sysinternals.Suite",
    "mitmproxy.mitmproxy",
    "upx.upx",
    "Hex-Rays.IDA.Free",
    "Google.AndroidStudio",
    "BlueStacks.BlueStacks"
)

foreach ($pkg in $wingetPackages) {
    Write-Host " -> Kuruluyor: $pkg" -ForegroundColor Gray
    winget install -e --id $pkg --accept-source-agreements --accept-package-agreements --silent
}

# PATH guncelle (Java ve Python icin)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# 2. Dogrudan indirilecek RE Araclari (Ghidra, CyberChef, CFF Explorer, JADX, JD-GUI, Bytecode Viewer, APKStudio, Recaf, FLOSS, CAPA, Binary Ninja)
Write-Host "`n[2/4] Ozel Tersine Muhendislik araclari C:\RE_Tools altina indiriliyor..." -ForegroundColor Yellow

function Download-And-Extract($name, $url, $destFolder) {
    Write-Host " -> Indiriliyor: $name" -ForegroundColor Green
    $zipFile = "$dlDir\$name.zip"
    curl.exe -L -s --retry 3 -o $zipFile $url
    if (Test-Path $zipFile) {
        New-Item -ItemType Directory -Force -Path $destFolder | Out-Null
        tar.exe -xf $zipFile -C $destFolder
    }
}

# Ghidra 12.2
Download-And-Extract "Ghidra" "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.2_build/ghidra_12.2_PUBLIC_20261016.zip" "$baseDir\Ghidra"

# CyberChef
Download-And-Extract "CyberChef" "https://github.com/gchq/CyberChef/releases/download/v11.5.0/CyberChef_8cd426dd4f40f1423912d5fad91b578a86a65112.zip" "$baseDir\CyberChef"

# JADX-GUI (with JRE)
Download-And-Extract "JADX" "https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-gui-1.5.6-with-jre-win.zip" "$baseDir\JADX"

# APK Studio
Download-And-Extract "ApkStudio" "https://github.com/vaibhavpandeyvpz/apkstudio/releases/download/v6.3.0/ApkStudio-Windows-x64.zip" "$baseDir\ApkStudio"

# JD-GUI
Download-And-Extract "JD-GUI" "https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-windows-1.6.6.zip" "$baseDir\JD-GUI"

# FLOSS & CAPA (Mandiant FLARE araclari)
Download-And-Extract "FLOSS" "https://github.com/mandiant/flare-floss/releases/download/v3.2.0/floss-v3.2.0-windows.zip" "$baseDir\FLOSS"
Download-And-Extract "CAPA" "https://github.com/mandiant/capa/releases/download/v10.0.0/capa-v10.0.0-windows.zip" "$baseDir\CAPA"

# Bytecode Viewer (Java/APK Reverse Suite)
Write-Host " -> Indiriliyor: Bytecode Viewer" -ForegroundColor Green
New-Item -ItemType Directory -Force -Path "$baseDir\BytecodeViewer" | Out-Null
curl.exe -L -s -o "$baseDir\BytecodeViewer\Bytecode-Viewer.jar" "https://github.com/Konloch/bytecode-viewer/releases/download/v2.13.2/Bytecode-Viewer-2.13.2.jar"
"@echo off`r`nstart javaw -jar `"$baseDir\BytecodeViewer\Bytecode-Viewer.jar`"" | Set-Content "$baseDir\BytecodeViewer\BytecodeViewer_Baslat.bat"

# Recaf (Modern Java Bytecode Editor)
Write-Host " -> Indiriliyor: Recaf" -ForegroundColor Green
New-Item -ItemType Directory -Force -Path "$baseDir\Recaf" | Out-Null
curl.exe -L -s -o "$baseDir\Recaf\recaf-launcher.jar" "https://github.com/Col-E/Recaf/releases/download/4.0.0-alpha/recaf-launcher-gui-0.8.8.jar"
"@echo off`r`nstart javaw -jar `"$baseDir\Recaf\recaf-launcher.jar`"" | Set-Content "$baseDir\Recaf\Recaf_Baslat.bat"

# APKTool
Write-Host " -> Indiriliyor: APKTool" -ForegroundColor Green
New-Item -ItemType Directory -Force -Path "$baseDir\Apktool" | Out-Null
curl.exe -L -s -o "$baseDir\Apktool\apktool.jar" "https://github.com/iBotPeaches/Apktool/releases/download/v3.0.3/apktool_3.0.3.jar"
curl.exe -L -s -o "$baseDir\Apktool\apktool.bat" "https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/windows/apktool.bat"

# CFF Explorer (Explorer Suite)
Write-Host " -> Indiriliyor ve Kuruluyor: CFF Explorer (Explorer Suite)" -ForegroundColor Green
$cffExe = "$dlDir\ExplorerSuite.exe"
curl.exe -L -s -A "Mozilla/5.0" -o $cffExe "https://ntcore.com/files/ExplorerSuite.exe"
if (Test-Path $cffExe) {
    Start-Process -FilePath $cffExe -ArgumentList "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART" -Wait
}

# Binary Ninja Free
Write-Host " -> Indiriliyor ve Kuruluyor: Binary Ninja Free" -ForegroundColor Green
$bnExe = "$dlDir\BinaryNinja-free.exe"
curl.exe -L -s -o $bnExe "https://cdn.binary.ninja/installers/BinaryNinja-free.exe"
if (Test-Path $bnExe) {
    Start-Process -FilePath $bnExe -ArgumentList "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART" -Wait
}

# 3. Python Frida & Objection (APK & Windows Dynamic Hooking)
Write-Host "`n[3/4] Python RE kutuphaneleri (Frida, Objection, pefile) kuruluyor..." -ForegroundColor Yellow
python -m pip install --upgrade pip --quiet
python -m pip install frida frida-tools objection pefile capstone unicorn keystone-engine --quiet

# 4. Masaustundeki RE_Tools klasorune kategorili kisayollari olustur
Write-Host "`n[4/4] Masaustu RE_Tools klasorunde kategorili kisayollar olusturuluyor..." -ForegroundColor Yellow

$wsh = New-Object -ComObject WScript.Shell
$searchPaths = @(
    "$baseDir",
    "$env:LOCALAPPDATA\Microsoft\WinGet\Packages",
    "$env:LOCALAPPDATA\Programs",
    "$env:ProgramFiles",
    "${env:ProgramFiles(x86)}"
)

function Make-Shortcut($categoryDir, $shortcutName, $filePattern) {
    $found = Get-ChildItem -Path $searchPaths -Filter $filePattern -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $lnk = $wsh.CreateShortcut("$categoryDir\$shortcutName.lnk")
        $lnk.TargetPath = $found.FullName
        $lnk.WorkingDirectory = $found.DirectoryName
        $lnk.Save()
        Write-Host "   [+] $shortcutName -> $(Split-Path $categoryDir -Leaf)" -ForegroundColor Cyan
    }
}

# 1. Disassembler & Decompiler
Make-Shortcut $cat1 "Ghidra" "ghidraRun.bat"
Make-Shortcut $cat1 "IDA Free" "ida64.exe"
Make-Shortcut $cat1 "Binary Ninja" "binaryninja.exe"
Make-Shortcut $cat1 "Cutter (Rizin)" "cutter.exe"
Make-Shortcut $cat1 "dnSpy (64-bit)" "dnSpy.exe"

# 2. Debugger
Make-Shortcut $cat2 "x64dbg" "x64dbg.exe"
Make-Shortcut $cat2 "x32dbg" "x32dbg.exe"

# 3. APK & Java Reverse
Make-Shortcut $cat3 "JADX-GUI (APK Decompiler)" "jadx-gui.exe"
Make-Shortcut $cat3 "APK Studio" "ApkStudio.exe"
Make-Shortcut $cat3 "JD-GUI (Java Decompiler)" "jd-gui.exe"
Make-Shortcut $cat3 "Bytecode Viewer" "BytecodeViewer_Baslat.bat"
Make-Shortcut $cat3 "Recaf (Java Editor)" "Recaf_Baslat.bat"
Make-Shortcut $cat3 "Android Studio (AVD Emulator)" "studio64.exe"
Make-Shortcut $cat3 "BlueStacks Emulator" "HD-Player.exe"

# 4. PE & Hex Analiz
Make-Shortcut $cat4 "CFF Explorer" "CFF Explorer.exe"
Make-Shortcut $cat4 "Detect It Easy (DIE)" "die.exe"
Make-Shortcut $cat4 "PE-bear" "PE-bear.exe"
Make-Shortcut $cat4 "ImHex (RE Hex Editor)" "imhex.exe"
Make-Shortcut $cat4 "HxD Hex Editor" "HxD.exe"
Make-Shortcut $cat4 "Resource Hacker" "ResourceHacker.exe"

# 5. Sistem, Ag & Yardimci
Make-Shortcut $cat5 "CyberChef (Offline)" "CyberChef*.html"
Make-Shortcut $cat5 "Everything (Hizli Arama)" "Everything.exe"
Make-Shortcut $cat5 "System Informer" "SystemInformer.exe"
Make-Shortcut $cat5 "Process Monitor (Procmon)" "Procmon64.exe"
Make-Shortcut $cat5 "Process Explorer" "procexp64.exe"
Make-Shortcut $cat5 "Autoruns" "Autoruns64.exe"
Make-Shortcut $cat5 "TCPView" "tcpview64.exe"
Make-Shortcut $cat5 "VMMap (Bellek Analizi)" "vmmap64.exe"
Make-Shortcut $cat5 "Wireshark" "Wireshark.exe"
Make-Shortcut $cat5 "Notepad++" "notepad++.exe"

Write-Host "`n================================================================" -ForegroundColor Green
Write-Host " TUM ARACLAR KURULDU VE MASAUSTU RE_Tools KLASORUNE DIZILDI!    " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
pause
