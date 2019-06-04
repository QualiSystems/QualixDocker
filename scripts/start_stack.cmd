@echo off
SET CURRENT=%~dp0
cd %CURRENT%

set STACK_NAME=qualix
set STACK_FILE=docker-compose.yml
docker stack deploy --compose-file %STACK_FILE% %STACK_NAME%