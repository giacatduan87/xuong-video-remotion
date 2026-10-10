@echo off
title Cai dat Xuong dung video Remotion
cd /d "%~dp0"
if exist "%~dp0goi.enc" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0cai.ps1" -GoiNoiBo "%~dp0goi.enc" %*
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0cai.ps1" %*
)
