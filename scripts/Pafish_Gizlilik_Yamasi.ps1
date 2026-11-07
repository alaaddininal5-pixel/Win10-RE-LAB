$ErrorActionPreference = "SilentlyContinue"
New-Item -ItemType Directory -Force -Path "C:\RE_Tools\Stealth" | Out-Null

$scriptContent = @'
Get-ChildItem "HKLM:\HARDWARE\DEVICEMAP\Scsi" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    $prop = Get-ItemProperty $_.PsPath -ErrorAction SilentlyContinue
    if ($prop.Identifier -match "QEMU") {
        Set-ItemProperty -Path $_.PsPath -Name "Identifier" -Value "Samsung SSD 990 PRO 1TB"
    }
}
Set-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System" -Name "SystemBiosVersion" -Value @("ASUS - 3205", "American Megatrends - 50011")
Set-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System" -Name "VideoBiosVersion" -Value @("NVIDIA RTX 4070 BIOS")
'@

Set-Content -Path "C:\RE_Tools\Stealth\anti_vm.ps1" -Value $scriptContent -Force
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\RE_Tools\Stealth\anti_vm.ps1"

schtasks /create /tn "AntiVM_Stealth" /tr "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\RE_Tools\Stealth\anti_vm.ps1" /sc ONLOGON /rl HIGHEST /f

Write-Host "`n[+] QEMU Disk ve Bochs BIOS imzalari temizlendi (ve her acilisa sabitlendi)!" -ForegroundColor Green
pause
