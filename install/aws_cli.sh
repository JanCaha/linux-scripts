#!/bin/bash
set -euo pipefail

START_DIR="$(pwd)"

echo "🚀 Installing AWS CLI"

cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

echo "📥 Downloaded awscliv2.zip"
echo "📦 Unzipping awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install

echo "✅ AWS CLI installed"

cd "$START_DIR"