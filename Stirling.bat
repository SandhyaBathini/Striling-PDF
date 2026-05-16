@echo off
REM ============================================================
REM Demo-ready batch to run Stirling PDF and open browser
REM ============================================================

cd /d %~dp0
cd app\core\build\libs

set JAR_FILE=stirling-pdf-1.3.2.jar

IF NOT EXIST %JAR_FILE% (
    echo JAR file not found! Make sure the project is built.
    pause
    exit /b 1
)

echo Starting Stirling PDF application...
echo Please wait for the server to start...

REM Run the JAR in the background and log output
start "" /B java -jar %JAR_FILE% > stirling.log 2>&1

:WAIT_LOOP
REM Check stirling.log for the line containing "Tomcat started on port"
findstr /i "Tomcat started on port" stirling.log >nul
IF ERRORLEVEL 1 (
    timeout /t 1 >nul
    goto WAIT_LOOP
)

REM Extract the port number reliably
for /f "tokens=3 delims=:" %%a in ('findstr /i "Tomcat started on port" stirling.log') do (
    set PORT=%%a
)

REM Remove spaces if any
set PORT=%PORT: =%

REM Display only the server URL
echo ============================================================
echo Server is running at: http://localhost:8080
echo ============================================================

REM Open default browser to the URL
start http://localhost:8080
pause
