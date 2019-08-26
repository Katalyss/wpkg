:: Script d'install ou de desinstall de wsusoffline pour scribe, under GPL licence
:: Auteur Olivier Lacroix modifié par David Pailler
:: Date juillet 2012
::@echo off
::cd %SystemDrive%

If "%1" == "Uninstall" Goto UNINSTALL

echo Installation de wsusoffline : desactivation des mises a jour auto de windows
:: Desactive les mises a jour automatiques de windows
reg.exe ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /V AUOptions /t REG_DWORD /d 1 /f
:: Active le service de mises a jour necessaire a wsusoffline
%SOFTWARE%\tools\nircmdc service auto wuauserv
%SOFTWARE%\tools\nircmdc service start wuauserv
:: Desactive le centre de securite
%SOFTWARE%\tools\nircmdc service disabled wscsvc
%SOFTWARE%\tools\nircmdc service stop wscsvc

if not exist "%SystemDrive%\netinst\logs" mkdir "%SystemDrive%\netinst\logs"
if "%errorlevel%"=="0" echo Install OK : %DATE%, %TIME%

Goto FIN

:UNINSTALL
echo Desinstallation de wsusoffline : reactivation des mises a jour auto de windows
:: Reactive les mises a jour avec install automatique
reg.exe ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /V AUOptions /t REG_DWORD /d 4 /f
:: Active le service de mises a jour avec demarrage auto au boot et mise en service immediate
::%SOFTWARE%\tools\nircmdc service auto wuauserv
::%SOFTWARE%\tools\nircmdc service start wuauserv
:: Active le centre de securite avec demarrage auto au boot et mise en service immediate
%SOFTWARE%\tools\nircmdc service auto wscsvc
%SOFTWARE%\tools\nircmdc service start wscsvc
del /F %SYSTEMDRIVE%\netinst\logs\offlineupdate-install.log

:FIN
:: astuce, forcer errorlevel=0
dir > nul
