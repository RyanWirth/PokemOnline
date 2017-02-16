@echo off
set FLEX_SDK=C:\Users\Ryan\AppData\Local\FlashDevelop\Apps\ascsdk\18.0.0
set ANDROID_SDK=C:\Program Files (x86)\FlashDevelop\Tools\android
set PATH=%FLEX_SDK%\bin;%PATH%
set PATH=%PATH%;%ANDROID_SDK%\platform-tools


set SIGNING_OPTIONS=-storetype pkcs12 -keystore "cert\Self-Signed.p12" 
set APP_XML=application.xml
set DIST_PATH=dist
set DIST_NAME=windows
set FILE_OR_DIR=-e "bin/PokemOnline.swf" "bin/PokemOnline.swf" -e "icons/PokemOnline32.png" "icons/PokemOnline32.png"

set OUTPUT=%DIST_PATH%\%DIST_NAME%

if not exist "%DIST_PATH%" md "%DIST_PATH%"

set AIR_PACKAGE=adt -package -tsa none %SIGNING_OPTIONS% -target bundle %OUTPUT% %APP_XML% %FILE_OR_DIR%

call where adt
call adt -version
echo $ %AIR_PACKAGE%
call %AIR_PACKAGE%