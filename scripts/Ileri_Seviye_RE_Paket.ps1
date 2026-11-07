$ErrorActionPreference = "SilentlyContinue"
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   ILERI SEVIYE (PRO) RE ARACLARI KURULUMU BASLIYOR...          " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

$baseDir = "C:\RE_Tools"
$dlDir   = "C:\RE_Tools\_Downloads"
$deskDir = "$env:USERPROFILE\Desktop\RE_Tools"
$cat6    = "$deskDir\6_Unpacker_Dumper_ve_Pro_Araclar"

New-Item -ItemType Directory -Force -Path $baseDir, $dlDir, $cat6 | Out-Null

function Download-And-Extract($name, $url, $destFolder) {
    Write-Host " -> Indiriliyor: $name" -ForegroundColor Green
    $zipFile = "$dlDir\$name.zip"
    curl.exe -L -s --retry 3 -A "Mozilla/5.0" -o $zipFile $url
    if (Test-Path $zipFile) {
        New-Item -ItemType Directory -Force -Path $destFolder | Out-Null
        tar.exe -xf $zipFile -C $destFolder
    }
}

# 1. HollowsHunter & PE-sieve (Otomatik Bellekten Unpacker & Injected PE Dumper)
Write-Host "`n[1/5] HollowsHunter ve PE-sieve (Bellek Unpacker) indiriliyor..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$baseDir\HollowsHunter" | Out-Null
curl.exe -L -s -o "$baseDir\HollowsHunter\hollows_hunter64.exe" "https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.1.1/hollows_hunter64.exe"
curl.exe -L -s -o "$baseDir\HollowsHunter\hollows_hunter32.exe" "https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.1.1/hollows_hunter32.exe"
curl.exe -L -s -o "$baseDir\HollowsHunter\pe-sieve64.exe" "https://github.com/hasherezade/pe-sieve/releases/download/v0.4.1.1/pe-sieve64.exe"
curl.exe -L -s -o "$baseDir\HollowsHunter\pe-sieve32.exe" "https://github.com/hasherezade/pe-sieve/releases/download/v0.4.1.1/pe-sieve32.exe"

# 2. de4dot-cex (.NET & ConfuserEx Deobfuscator) ve ExtremeDumper (.NET Memory Dumper)
Write-Host "`n[2/5] de4dot-cex (.NET Sifre Cozucu) ve ExtremeDumper indiriliyor..." -ForegroundColor Yellow
Download-And-Extract "de4dot" "https://github.com/ViRb3/de4dot-cex/releases/download/v4.0.0/de4dot-cex.zip" "$baseDir\de4dot"
Download-And-Extract "ExtremeDumper" "https://github.com/wwh1004/ExtremeDumper/releases/download/v4.0.0.1/ExtremeDumper.zip" "$baseDir\ExtremeDumper"

# 3. ScyllaHide (x64dbg & x32dbg icine otomatik Anti-Anti-Debug kurulumu!)
Write-Host "`n[3/5] ScyllaHide indiriliyor ve x64dbg / x32dbg icine otomatik entegre ediliyor..." -ForegroundColor Yellow
Download-And-Extract "ScyllaHide" "https://github.com/x64dbg/ScyllaHide/releases/download/v1.4/ScyllaHide_2023-03-24_13-03.zip" "$baseDir\ScyllaHide"

$x64dbgFound = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\WinGet\Packages", "C:\RE_Tools", "$env:ProgramFiles" -Filter "x64dbg.exe" -Recurse | Select-Object -First 1
if ($x64dbgFound) {
    $x64Plugins = Join-Path $x64dbgFound.DirectoryName "plugins"
    New-Item -ItemType Directory -Force -Path $x64Plugins | Out-Null
    Copy-Item -Path "$baseDir\ScyllaHide\Release\x64\plugins\*" -Destination $x64Plugins -Recurse -Force
    Copy-Item -Path "$baseDir\ScyllaHide\Release\scylla_hide.ini" -Destination $x64Plugins -Force
    Write-Host "   [+] ScyllaHide -> x64dbg icine basariyla kuruldu!" -ForegroundColor Cyan
}
$x32dbgFound = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\WinGet\Packages", "C:\RE_Tools", "$env:ProgramFiles" -Filter "x32dbg.exe" -Recurse | Select-Object -First 1
if ($x32dbgFound) {
    $x32Plugins = Join-Path $x32dbgFound.DirectoryName "plugins"
    New-Item -ItemType Directory -Force -Path $x32Plugins | Out-Null
    Copy-Item -Path "$baseDir\ScyllaHide\Release\x86\plugins\*" -Destination $x32Plugins -Recurse -Force
    Copy-Item -Path "$baseDir\ScyllaHide\Release\scylla_hide.ini" -Destination $x32Plugins -Force
    Write-Host "   [+] ScyllaHide -> x32dbg icine basariyla kuruldu!" -ForegroundColor Cyan
}

# 4. FakeNet-NG, API Monitor v2, UniExtract2, Regshot, PyInstxtractor ve Pafish
Write-Host "`n[4/5] FakeNet-NG, API Monitor v2, UniExtract2, Regshot, PyInstxtractor ve Pafish kuruluyor..." -ForegroundColor Yellow
Download-And-Extract "FakeNet-NG" "https://github.com/mandiant/flare-fakenet-ng/releases/download/v3.5/fakenet3.5.zip" "$baseDir\FakeNet-NG"
Download-And-Extract "UniExtract2" "https://github.com/Bioruebe/UniExtract2/releases/download/v2.0.0-rc.3/UniExtractRC3.zip" "$baseDir\UniExtract2"
Download-And-Extract "APIMonitor" "http://www.rohitab.com/download/api-monitor-v2r13-x86-x64.zip" "$baseDir\APIMonitor"

winget install -e --id Regshot.Regshot --accept-source-agreements --accept-package-agreements --silent
winget install -e --id InnoExtract.InnoExtract --accept-source-agreements --accept-package-agreements --silent

# PyInstxtractor (Python .exe Unpacker)
New-Item -ItemType Directory -Force -Path "$baseDir\PyInstxtractor" | Out-Null
curl.exe -L -s -o "$baseDir\PyInstxtractor\pyinstxtractor.py" "https://raw.githubusercontent.com/extremecoders-re/pyinstxtractor/master/pyinstxtractor.py"

# Pafish (Anti-VM / Anti-Debug Lab Test Araci)
New-Item -ItemType Directory -Force -Path "$baseDir\Pafish" | Out-Null
curl.exe -L -s -o "$baseDir\Pafish\pafish64.exe" "https://github.com/a0rtega/pafish/releases/download/v0.6/pafish64.exe"
curl.exe -L -s -o "$baseDir\Pafish\pafish32.exe" "https://github.com/a0rtega/pafish/releases/download/v0.6/pafish.exe"

# HollowsHunter, PE-sieve ve de4dot'u sistem PATH'ine ekle
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
foreach ($p in @("$baseDir\HollowsHunter", "$baseDir\de4dot", "$baseDir\PyInstxtractor")) {
    if ((Test-Path $p) -and ($currentPath -notlike "*$p*")) {
        $currentPath += ";$p"
    }
}
[System.Environment]::SetEnvironmentVariable("Path", $currentPath, "Machine")

# Sag Tik Menusune de4dot (.NET Sifre Cozucu) ve UniExtract2 ekle
if (Test-Path "$baseDir\de4dot\de4dot-x64.exe") {
    $regPath = "Registry::HKEY_CLASSES_ROOT\*\shell\7. de4dot ile .NET Sifresini Coz (Deobfuscate)"
    New-Item -Path "$regPath\command" -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name "(Default)" -Value "7. de4dot ile .NET Sifresini Coz (Deobfuscate)"
    Set-ItemProperty -Path $regPath -Name "Icon" -Value "`"$baseDir\de4dot\de4dot-x64.exe`""
    Set-ItemProperty -Path "$regPath\command" -Name "(Default)" -Value "`"$baseDir\de4dot\de4dot-x64.exe`" `"%1`""
}

# 5. Masaustundeki RE_Tools\6_Unpacker_Dumper_ve_Pro_Araclar klasorune kisayollari diz
Write-Host "`n[5/5] Masaustune kisayollar olusturuluyor..." -ForegroundColor Yellow
$wsh = New-Object -ComObject WScript.Shell
$searchPaths = @("$baseDir", "$env:LOCALAPPDATA\Microsoft\WinGet\Packages", "$env:ProgramFiles", "${env:ProgramFiles(x86)}")

function Make-Shortcut($categoryDir, $shortcutName, $filePattern) {
    $found = Get-ChildItem -Path $searchPaths -Filter $filePattern -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $lnk = $wsh.CreateShortcut("$categoryDir\$shortcutName.lnk")
        $lnk.TargetPath = $found.FullName
        $lnk.WorkingDirectory = $found.DirectoryName
        $lnk.Save()
        Write-Host "   [+] $shortcutName eklendi." -ForegroundColor Cyan
    }
}

Make-Shortcut $cat6 "ExtremeDumper (.NET & Bellek Dumper)" "ExtremeDumper.exe"
Make-Shortcut $cat6 "API Monitor v2 (64-bit)" "apimonitor-x64.exe"
Make-Shortcut $cat6 "API Monitor v2 (32-bit)" "apimonitor-x86.exe"
Make-Shortcut $cat6 "UniExtract2 (Setup & Installer Acici)" "UniExtract.exe"
Make-Shortcut $cat6 "FakeNet-NG (Sahte Internet)" "fakenet.exe"
Make-Shortcut $cat6 "Regshot (Registry Fark Analizi)" "Regshot-x64-Unicode.exe"
Make-Shortcut $cat6 "Pafish (Anti-VM Gizlilik Testi)" "pafish64.exe"
Make-Shortcut $cat6 "HollowsHunter (Komut Satiri Klasoru)" "hollows_hunter64.exe"

Write-Host "`n================================================================" -ForegroundColor Green
Write-Host " TUM ILERI SEVIYE (PRO) RE ARACLARI BASARIYLA KURULDU!          " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
pause
