wmic nteventlog where logfilename='security' cleareventlog > nul
wmic nteventlog where logfilename='system' cleareventlog > nul
wmic nteventlog where logfilename='application' cleareventlog > nul
