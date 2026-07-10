@echo off
cd /d "%~dp0"
echo ========================================
echo  Available Flutter Devices
echo ========================================
flutter devices
echo.
echo ========================================
echo  Starting flutter run (device picker)
echo ========================================
flutter run
pause
