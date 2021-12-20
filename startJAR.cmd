@echo off

rem get it from file settings.gradle
set projectName=LusherTest

rem get it from file build.gradle
set version=0.1.0-RELEASE

rem set YOUR path to JRE
set JAVA_HOME=C:\Program Files\Java\jre1.8.0_271

set curDir=%~dp0

start "%projectName%" /MAX "%JAVA_HOME%\bin\java.exe" -jar "%curDir%build\libs\%projectName%-%version%.jar"
