@echo off
REM Timely.AI Setup Script for Windows

echo =========================================
echo   Timely.AI Setup Script
echo =========================================
echo.

REM Check Python installation
echo Checking Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed. Please install Python 3.8 or higher.
    exit /b 1
)
echo Python found: 
python --version

REM Check Flutter installation
echo Checking Flutter installation...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Flutter is not installed. Please install Flutter SDK.
    exit /b 1
)
echo Flutter found:
flutter --version | findstr Flutter

echo.
echo =========================================
echo   Setting up Backend
echo =========================================

cd server

REM Create virtual environment
echo Creating Python virtual environment...
python -m venv venv

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Install Python dependencies
echo Installing Python dependencies...
pip install flask flask-cors ortools

echo Backend setup complete!

cd ..

echo.
echo =========================================
echo   Setting up Frontend
echo =========================================

cd front-end\timely_ai

REM Install Flutter dependencies
echo Installing Flutter dependencies...
flutter pub get

echo Frontend setup complete!

cd ..\..

echo.
echo =========================================
echo   Setup Complete!
echo =========================================
echo.
echo To start the application:
echo.
echo 1. Start the backend server:
echo    cd server
echo    venv\Scripts\activate
echo    python app.py
echo.
echo 2. In a new terminal, start the frontend:
echo    cd front-end\timely_ai
echo    flutter run -d windows    # or -d edge, -d chrome, etc.
echo.
echo For more information, see README.md
echo.

pause
