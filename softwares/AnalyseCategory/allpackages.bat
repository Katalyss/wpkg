rem @echo off
if not exist %systemDrive%\netinst mkdir %SystemDrive%\netinst

rem récupération de l'adresse IP du scribe
for /f "tokens=3" %%i in ('REG.EXE QUERY "HKLM\SOFTWARE\Eole\Scribe" ^| find "ip_scribe"') do set IPSCRIBE=%%i

if exist %SystemDrive%\netinst\ok.txt del /F /Q %SystemDrive%\netinst\ok.txt
pushd %SystemDrive%
cd %SystemDrive%\netinst

echo 1 on se met au bon endroit pour le test de depart
If not exist allpackages.xml GOTO Allpackages

dir /TW allpackages.xml | find "/" >%SystemDrive%\netinst\tmp.txt 
echo tmp.txt est cree pour la comparaison  avec la date d'aujourd'hui
call :Process
if  %datetmp% NEQ %date:~0,2%%date:~3,2%%date:~6,4% ( GOTO Allpackages ) ELSE ( GOTO Exit )

:Allpackages
echo on cree allpackages ou on le met a jour

echo on a cree analysecategory si ce n'est pas deja fait
%ComSpec% /C if not exist %Systemdrive%\netinst\AnalyseCategory.xsl xcopy %SOFTWARE%\AnalyseCategory.xsl %SystemDrive%\netinst /C /I /F /H /R /y

net use Z: \\scribe\wpkg
set WPKGROOT=\\scribe\wpkg
pushd Z:\packages
echo : on cree la liste des xml
DIR /B /C *.xml > %SystemDrive%\netinst\listexml.txt

echo on genere allpackages.xml si il y a eu modification des xml
for /f "delims=" %%a in ('dir *.xml /b / a:a') do (
if exist %SystemDrive%\netinst\ok.txt GOTO Fin
echo. > %SystemDrive%\netinst\allpackages.txt
For /F  %%F in (%SystemDrive%\netinst\listexml.txt) DO TYPE %WPKGROOT%\packages\%%F >> %SystemDrive%\netinst\allpackages.txt 
%SystemRoot%\System32\find /V "packages" < %SystemDrive%\netinst\allpackages.txt >%SystemDrive%\netinst\allpackages1.txt
%SystemRoot%\System32\find /V "?xml version=" < %SystemDrive%\netinst\allpackages1.txt >%SystemDrive%\netinst\allpackages2.txt
echo ^<^?xml version="1.0" encoding="UTF-8"^?^> > %SystemDrive%\netinst\allpackages.xml
echo ^<packages^> >> %SystemDrive%\netinst\allpackages.xml
TYPE %SystemDrive%\netinst\allpackages2.txt >>%SystemDrive%\netinst\allpackages.xml
::echo ^<^/package^> >> %SystemDrive%\netinst\allpackages.xml
echo ^<^/packages^> >> %SystemDrive%\netinst\allpackages.xml
echo. >%SystemDrive%\netinst\ok.txt
echo on efface les fichiers temporaires
del /F /Q %SystemDrive%\netinst\allpackages.txt
del /F /Q %SystemDrive%\netinst\allpackages1.txt
del /f /Q %SystemDrive%\netinst\allpackages2.txt
:Fin 
echo allpackages a jour
)
pushd %SystemDrive%
NET USE Z: /DELETE /YES
echo Z a ete demonte
Goto Exit

:Process
echo on cree la variable datetmp
For /F "tokens=1-4 delims=/ " %%i in (%SystemDrive%\netinst\tmp.txt) do set datetmp=%%i%%j%%k
echo c'est fait
:Exit
echo Allpackages est a jour
if exist %SystemDrive%\netinst\ok.txt del /F /Q %SystemDrive%\netinst\ok.txt
if exist %SystemDrive%\netinst\tmp.txt del /F /Q %SystemDrive%\netinst\tmp.txt
