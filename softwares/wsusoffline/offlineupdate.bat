@echo off
:: Script wpkg modifie par Olivier Lacroix, puis par david Pailler (juillet 2012)
:: Installe les mises à jour desirees, parametrees dans un fichier texte sur Scribe

set ARG=

:: Recuperation des parametrages par defaut ou specifiques a un parc
FOR /F "tokens=1,2 delims== " %%a IN (%SOFTWARE%\wsusoffline\default.txt) DO (
	rem ECHO %%a=%%b
	if not "%%b"=="" (
		set %%a=%%b
		if "%%b"=="true" set ARG=!ARG! /%%a
		rem echo ARG=!ARG!
	)
)
 
:: Make sure that the log directly exists and is hidden
if not exist %SystemDrive%\netinst\wpkg mkdir %SystemDrive%\netinst\wpkg
attrib +H %SystemDrive%\netinst
 
:: Update the system and log it
pushd %SOFTWARE%\wsusoffline\wsusoffline\client
echo Execution de : cmd /c cmd\DoUpdate.cmd !ARG!
cmd /c cmd\DoUpdate.cmd !ARG!
::>> %SOFTWARE%\.EtatsClients\wsusoffline\%COMPUTERNAME%-wsusoffline.log
popd %SOFTWARE%\wsusoffline\wsusoffline\client
::date /T >> %SOFTWARE%\.EtatsClients\wsusoffline\%COMPUTERNAME%-wsusoffline.log
@echo on
