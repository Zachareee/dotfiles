@echo off
powershell -noprofile "start-process powershell -verb runas ""-noprofile -command ""cd %~dp0; Get-ChildItem -Filter *.json | %% { winget import `$_.name --accept-package-agreements --accept-source-agreements }; pause"""""
