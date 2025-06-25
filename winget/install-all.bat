@echo off
cd /D "%~dp0"
for %%i in (*.json) do (
  start powershell -noprofile "winget import %%i --accept-package-agreements --accept-source-agreements"
)
