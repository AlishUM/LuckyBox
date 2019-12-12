@Echo Off
Setlocal EnableDelayedExpansion
:reEnter
echo.
echo Select item to program:
echo.
echo 1 - Update only program.
echo 2 - Update only Web interface.
echo 3 - Update program and WEB interface.
echo 4 - Erase entire memory of the module. Update program and WEB interface.
echo Q - Exit.
echo.
set /p InputFile=
echo.
if /i "%InputFile%" == "1" goto stepSetCOM
if /i "%InputFile%" == "2" goto stepSetCOM
if /i "%InputFile%" == "3" goto stepSetCOM
if /i "%InputFile%" == "4" goto stepSetCOM
if /i "%InputFile%" == "Q" goto exitBat
goto reEnter

:stepSetCOM
echo Enter COM port number:
for /f "tokens=*" %%i in ('REG QUERY HKLM\HARDWARE\DEVICEMAP\SERIALCOMM /s') do (
Set a1=%%i
Set a1=!a1:~-7!
Set a2=!a1:~0,1!
Set a1=!a1: =!
Set a3=!a1:COM=!
if "!a2!" EQU " " echo.!a3! - !a1!
)
echo Q - Exit.
echo.
Set /p InputCom=
if /i "%InputCom%" == "Q" goto exitBat
Set InputCom=%InputCom:COM=%

echo.
echo Enter COM port speed:
echo.
echo 1 - 115200
echo 2 - 256000
echo 3 - 512000
echo 4 - 921600
echo Q - Exit.
echo.
Set /p InputSpeed=
echo.
set "SpeedSet=115200"
if /i "%InputSpeed%" == "1" set "SpeedSet=115200"
if /i "%InputSpeed%" == "2" set "SpeedSet=256000"
if /i "%InputSpeed%" == "3" set "SpeedSet=512000"
if /i "%InputSpeed%" == "4" set "SpeedSet=921600"
if /i "%InputSpeed%" == "Q" goto exitBat

:goProg
if /i "%InputFile%" == "1" goto progSketch
if /i "%InputFile%" == "2" goto progWeb
if /i "%InputFile%" == "3" goto ProgSketchAndWeb
if /i "%InputFile%" == "4" goto eraseProgSketchAndWeb
goto exitBat

:progSketch
.\DataFiles\esptool.exe -vv -cd nodemcu -cb "%SpeedSet%" -cp COM"%InputCom%" -ca 0x00000 -cf .\DataFiles\LuckyBox.ino.bin
goto endBat

:progWeb
.\DataFiles\esptool.exe -vv -cd nodemcu -cb "%SpeedSet%" -cp COM"%InputCom%" -ca 0x300000 -cf .\DataFiles\LuckyBox.spiffs.bin
goto endBat

:progSketchAndWeb
.\DataFiles\esptool.exe -vv -cd nodemcu -cb "%SpeedSet%" -cp COM"%InputCom%" -ca 0x00000 -cf .\DataFiles\LuckyBox.ino.bin
.\DataFiles\esptool.exe -vv -cd nodemcu -cb "%SpeedSet%" -cp COM"%InputCom%" -ca 0x300000 -cf .\DataFiles\LuckyBox.spiffs.bin
goto endBat

:eraseProgSketchAndWeb
.\DataFiles\esptool.exe -vv -cd nodemcu -cb "%SpeedSet%" -cp COM"%InputCom%" -ca 0x0 -cz 0x400000 -ca 0x00000 -cf .\DataFiles\LuckyBox.ino.bin
.\DataFiles\esptool.exe -vv -cd nodemcu -cb "%SpeedSet%" -cp COM"%InputCom%" -ca 0x300000 -cf .\DataFiles\LuckyBox.spiffs.bin
goto endBat

:endBat
echo.
pause

:exitBat