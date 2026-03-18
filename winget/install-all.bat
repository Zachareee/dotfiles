@echo off
sudo run powershell -noprofile -command "cd %~dp0; Get-ChildItem -Filter *.json | %% { winget import $_.name --accept-package-agreements --accept-source-agreements --disable-interactivity }"
