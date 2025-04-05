#!/bin/bash

set -e

VENV_DIR="/root/pve-migrate-venv"
SCRIPT_NAME="pve-migrate.py"

echo "🔧 Installiere benötigte Pakete..."
apt update
apt install -y python3 python3-venv python3-pip

echo "🐍 Erstelle Python-Virtualenv unter $VENV_DIR ..."
python3 -m venv "$VENV_DIR"

echo "📦 Installiere 'questionary' im VENV..."
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install questionary

echo "✅ VENV ist fertig eingerichtet."

if [[ -f "$SCRIPT_NAME" ]]; then
  echo "🚀 Starte direkt $SCRIPT_NAME ..."
  python "$SCRIPT_NAME"
else
  echo "ℹ️  Du kannst dein Migrations-Script mit folgendem Befehl starten:"
  echo ""
  echo "  source $VENV_DIR/bin/activate"
  echo "  python $SCRIPT_NAME"
  echo ""
fi
