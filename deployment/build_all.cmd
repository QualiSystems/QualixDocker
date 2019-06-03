@echo off

SET CURRENT=%cd%

SET STEP=guacamole
echo Building %STEP%
cd ..\guacamole_image\
call build.cmd > guacamole_image.log
IF %ERRORLEVEL% NEQ 0 (
  goto :setError
)
cd %CURRENT%

SET STEP=quacd
echo Building %STEP%
cd ..\guacd_image\
call build.cmd > guacd_image.log
IF %ERRORLEVEL% NEQ 0 (
  goto :setError
)
cd %CURRENT%

goto :done_ok



:setError
echo Building %STEP% image Failed! please check %STEP% log
Exit /B 1
goto :eof

:done_ok
echo Building images succeeded
Exit /B 0
goto :eof