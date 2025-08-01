#!/bin/zsh

echo "🚀 Making $1 Scan of the PDF"

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <arg1> <arg2>"
    exit 1
fi

echo "📥 Activating Python environment"
source $MAIN_ENV_ACTIVATE

if [ -n "$VIRTUAL_ENV" ]; then
    echo "You are inside a virtual environment: $VIRTUAL_ENV"
else
    echo "You are NOT inside a virtual environment. This will cause issues, exiting."
    exit 1
fi

python3 ~/Scripts/python/scan_pdf.py "$1" "$2"

if [ $? -eq 0 ]; then
    echo "✅ PDF scan successful"
else
    echo "❌ PDF scan failed"
fi