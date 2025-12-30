#!/bin/bash

# Timely.AI Setup Script for Unix-based systems (macOS/Linux)

echo "========================================="
echo "  Timely.AI Setup Script"
echo "========================================="
echo ""

# Check Python installation
echo "Checking Python installation..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi
echo "✅ Python found: $(python3 --version)"

# Check Flutter installation
echo "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter SDK."
    exit 1
fi
echo "✅ Flutter found: $(flutter --version | head -1)"

echo ""
echo "========================================="
echo "  Setting up Backend"
echo "========================================="

cd server

# Create virtual environment
echo "Creating Python virtual environment..."
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install flask flask-cors ortools

echo "✅ Backend setup complete!"

cd ..

echo ""
echo "========================================="
echo "  Setting up Frontend"
echo "========================================="

cd front-end/timely_ai

# Install Flutter dependencies
echo "Installing Flutter dependencies..."
flutter pub get

echo "✅ Frontend setup complete!"

cd ../..

echo ""
echo "========================================="
echo "  Setup Complete!"
echo "========================================="
echo ""
echo "To start the application:"
echo ""
echo "1. Start the backend server:"
echo "   cd server"
echo "   source venv/bin/activate  # or 'venv\\Scripts\\activate' on Windows"
echo "   python app.py"
echo ""
echo "2. In a new terminal, start the frontend:"
echo "   cd front-end/timely_ai"
echo "   flutter run -d chrome    # or -d windows, -d edge, etc."
echo ""
echo "For more information, see README.md"
echo ""
