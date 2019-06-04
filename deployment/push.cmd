@echo off

SET QUACD=qualix_guacd
SET GIACAMOLE=qualix_guacamole

SET VERSION=1.0.0

SET TAG=moshe_tag
SET NAME=moshe_name

SET REPO=qualitesthub

REM Tagging the images
SET QUACD_TAG=%REPO%/%QUACD%:%VERSION%
SET GIACAMOLE_TAG=%REPO%/%GIACAMOLE%:%VERSION%
docker tag %QUACD%:latest %REPO%/%QUACD%:%VERSION%
docker tag %GIACAMOLE%:latest %REPO%/%GIACAMOLE%:%VERSION%


REM Login to Docker
SET DOCKER_USERNAME=qualitesthub
SET DOCKER_PASSWORD=12345678
echo Login to docker hub with username: %DOCKER_USERNAME%
docker login --username %DOCKER_USERNAME% --password %DOCKER_PASSWORD%


REM pushing the images
SET STEP=%QUACD%
docker image push %QUACD_TAG%
IF %ERRORLEVEL% NEQ 0 (
  goto :setError
)


SET STEP=%GIACAMOLE%
docker image push %GIACAMOLE_TAG%
IF %ERRORLEVEL% NEQ 0 (
  goto :setError
)

goto :done


REM callbacks
:setError
echo Pushing %STEP% image Failed! please check %STEP% log
Exit /B 1
goto :eof

:done
Exit /B 0
echo Pushing images succeeded
goto :eof