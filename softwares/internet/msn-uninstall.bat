SET MSNINF=%windir%\INF\msmsgs.inf

if not exist "%MSNINF%" GOTO FIN
RunDll32 advpack.dll,LaunchINFSection "%MSNINF%",BLC.Remove

:FIN

