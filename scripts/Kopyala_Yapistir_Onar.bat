@echo off
echo ========================================================
echo SPICE Kopyala-Yapistir Servisi Onariliyor...
echo ========================================================

:: Hizli Baslatmayi (Fast Startup) kapat (VirtIO Serial kopmasini engeller)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f

:: Servisi otomatik baslayacak ve cokerse 1 saniyede yeniden baslayacak sekilde ayarla
sc.exe config vdservice start= auto
sc.exe failure vdservice reset= 0 actions= restart/1000/restart/1000/restart/1000

:: Eskiden kalan asili vdagent varsa temizle ve servisi yeniden baslat
taskkill /F /IM vdagent.exe 2>nul
taskkill /F /IM vdservice.exe 2>nul
net stop vdservice 2>nul
net start vdservice

echo.
echo [+] SPICE Kopyala-Yapistir servisi baslatildi ve kalici olarak sabitlendi!
pause
