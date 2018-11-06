@Echo Off
:reEnter
echo.
echo �롥�� ᮮ⢥�����騩 �㭪�:
echo.
echo 1 - ������塞 ⮫쪮 �ணࠬ��.
echo 2 - ������塞 ⮫쪮 Web ����䥩�.
echo 3 - ������塞 �ணࠬ�� � Web ����䥩�.
echo 4 - ��ࠥ� ��� ������ �����. ������塞 �ணࠬ�� � Web ����䥩�.
echo Q - ��室.
echo.
set /p InputFile=
echo.
IF /i "%InputFile%" == "1" goto progSketch
IF /i "%InputFile%" == "2" goto progWeb
IF /i "%InputFile%" == "3" goto ProgSketchAndWeb
IF /i "%InputFile%" == "4" goto eraseProgSketchAndWeb
IF /i "%InputFile%" == "Q" goto exitBat

goto reEnter

:progSketch
echo ������ ����� COM ����:
echo.
Set /p $InputCom=    
.\DataFiles\esptool.exe -vv -cd nodemcu -cb 921600 -cp COM"%$InputCom%" -ca 0x00000 -cf .\DataFiles\LuckyBox.ino.bin
goto endBat

:progWeb
echo ������ ����� COM ����:
echo.
Set /p $InputCom=
.\DataFiles\esptool.exe -vv -cd nodemcu -cb 921600 -cp COM"%$InputCom%" -ca 0x300000 -cf .\DataFiles\LuckyBox.spiffs.bin
goto endBat

:progSketchAndWeb
echo ������ ����� COM ����:
echo.
Set /p $InputCom=    
.\DataFiles\esptool.exe -vv -cd nodemcu -cb 921600 -cp COM"%$InputCom%" -ca 0x00000 -cf .\DataFiles\LuckyBox.ino.bin
.\DataFiles\esptool.exe -vv -cd nodemcu -cb 921600 -cp COM"%$InputCom%" -ca 0x300000 -cf .\DataFiles\LuckyBox.spiffs.bin
goto endBat

:eraseProgSketchAndWeb
echo ������ ����� COM ����:
echo.
Set /p $InputCom=    
.\DataFiles\esptool.exe -vv -cd nodemcu -cb 921600 -cp COM"%$InputCom%" -ca 0x0 -cz 0x400000 -ca 0x00000 -cf .\DataFiles\LuckyBox.ino.bin
.\DataFiles\esptool.exe -vv -cd nodemcu -cb 921600 -cp COM"%$InputCom%" -ca 0x300000 -cf .\DataFiles\LuckyBox.spiffs.bin
goto endBat

:endBat
echo.
pause

:exitBat