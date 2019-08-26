
@echo Off
echo.
echo Ce batch patche le scribe.js afin de mettre en place le classement des raccourcis 
echo de programmes par categorie
echo puis il colle les fichiers necessaires au bon endroit dans u:\wpkg
pause
echo. 
echo voulez vous patcher le scribe.js?
pause
echo par securite, une copie de scribe.js est creer avant tout scribeori.js
pushd U:\wpkg
copy wpkg.js wpkgori.js /y
patch wpkg.js < U:\wpkg-manage\packages-eole\patch\scribejs.patch
echo wpkg.js est patché
pause
echo copie de allpackages.bat, AnalyseCategory.bat, AnalyseCategory.js, AnalyseCategory.xsl
echo dans %SOFTWARE%
copy U:\wpkg-manage\packages-eole\softwares\AnalyseCategory\AnalyseCategory.* U:\wpkg\softwares\ 
copy U:\wpkg-manage\packages-eole\softwares\AnalyseCategory\allpackages.bat U:\wpkg\softwares\ 
echo c'est fait
pause
exit
