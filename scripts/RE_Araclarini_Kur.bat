@echo off
echo ========================================================
echo Tersine Muhendislik (RE) Lab Araclari Kuruluyor...
echo ========================================================
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f

winget install -e --id 7zip.7zip --accept-source-agreements --accept-package-agreements
winget install -e --id Notepad++.Notepad++ --accept-source-agreements --accept-package-agreements
winget install -e --id x64dbg.x64dbg --accept-source-agreements --accept-package-agreements
winget install -e --id Hasherezade.PE-bear --accept-source-agreements --accept-package-agreements
winget install -e --id horsicq.DIE-engine --accept-source-agreements --accept-package-agreements
winget install -e --id WinsiderSS.SystemInformer --accept-source-agreements --accept-package-agreements
winget install -e --id Microsoft.Sysinternals.ProcessMonitor --accept-source-agreements --accept-package-agreements
winget install -e --id HxD.HxD --accept-source-agreements --accept-package-agreements
winget install -e --id dnSpyEx.dnSpy --accept-source-agreements --accept-package-agreements
winget install -e --id WiresharkFoundation.Wireshark --accept-source-agreements --accept-package-agreements
winget install -e --id Python.Python.3.12 --accept-source-agreements --accept-package-agreements

echo.
echo Kurulum tamamlandi!
pause
