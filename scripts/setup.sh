#!/bin/bash

echo "🔧 Setting up Noir development environment..."

# Detect OS
OS="$(uname)"

if [[ "$OS" == "Darwin" ]]; then
    echo "🍎 macOS detected"

  # Check Homebrew
  if ! command -v brew &> /dev/null
  then
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo "Installing SwiftLint and SwiftFormat..."
  brew install swiftlint swiftformat

elif [[ "$OS" == "Linux" ]]; then
    echo "🐧 Linux detected"

    echo "Please install SwiftLint manually for Linux"
fi

echo "✅ Setup complete"
