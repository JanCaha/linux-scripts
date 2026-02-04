#!/bin/bash
set -euo pipefail

echo "🚀 Installing Rust, Cargo and packages"

# Rust, Cargo and packages
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "✅ Rust installed"

echo "🚀 Installing Rust packages"

# sudo apt install cargo
cargo install sd
cargo install eza
export PATH=~/.cargo/bin:$PATH

echo "✅ Rust packages installed"