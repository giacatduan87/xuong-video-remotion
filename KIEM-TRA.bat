@echo off
title Kiem tra Xuong dung video Remotion
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0kiem-tra.ps1" %*
