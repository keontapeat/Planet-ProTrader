#!/bin/bash

# GOLDEX Universe CLI Launcher
# Quick launcher for your GPT-4 powered trading assistant

echo "🚀 Launching GOLDEX Universe CLI..."

# Check if OpenAI library is installed
if ! python3 -c "import openai" 2>/dev/null; then
    echo "📦 Installing OpenAI library (fixing Mac protected environment)..."
    
    # Try different installation methods for Mac
    if command -v pipx &> /dev/null; then
        echo "Using pipx..."
        pipx install openai
    elif pip3 install --user openai 2>/dev/null; then
        echo "✅ Installed with --user flag"
    elif pip3 install --break-system-packages openai 2>/dev/null; then
        echo "✅ Installed with --break-system-packages"
    else
        echo "⚠️  Manual install needed. Run one of these:"
        echo "   Option 1: pip3 install --user openai"
        echo "   Option 2: pip3 install --break-system-packages openai"
        echo "   Option 3: brew install pipx && pipx install openai"
        echo ""
        echo "🔧 Quick fix - running with --break-system-packages:"
        pip3 install --break-system-packages openai
    fi
fi

# Launch the CLI
python3 goldex_universe_cli.py