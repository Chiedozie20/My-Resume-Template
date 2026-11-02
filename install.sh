#!/usr/bin/env bash
# Install the TeX distribution + LaTeX packages required to build the resume.
# Auto-detects the OS and uses the appropriate package manager.
set -euo pipefail

# If a working pdflatex is already available, we're done.
if pdflatex --version >/dev/null 2>&1; then
    echo "pdflatex already installed: $(command -v pdflatex)"
    echo "Nothing to do."
    exit 0
fi

os="$(uname -s)"

case "$os" in
    Linux)
        if command -v dnf >/dev/null 2>&1; then
            echo "Detected Fedora / RHEL (dnf). Installing TeX Live..."
            sudo dnf install -y texlive-scheme-full
        elif command -v apt-get >/dev/null 2>&1; then
            echo "Detected Debian / Ubuntu (apt). Installing TeX Live..."
            sudo apt-get update
            sudo apt-get install -y \
                texlive-latex-recommended texlive-fonts-recommended \
                texlive-fonts-extra texlive-latex-extra
        elif command -v pacman >/dev/null 2>&1; then
            echo "Detected Arch (pacman). Installing TeX Live..."
            sudo pacman -S --noconfirm texlive-latexextra
        else
            echo "Unsupported Linux package manager."
            echo "Install TeX Live manually: https://tug.org/texlive/acquire-netinstall.html"
            exit 1
        fi
        ;;
    Darwin)
        if command -v brew >/dev/null 2>&1; then
            echo "Detected macOS (Homebrew). Installing MacTeX..."
            brew install --cask mactex-no-gui
        else
            echo "Detected macOS without Homebrew."
            echo "Install MacTeX manually: https://tug.org/mactex/mactex-download.html"
            exit 1
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        if command -v winget >/dev/null 2>&1; then
            echo "Detected Windows (winget). Installing MiKTeX..."
            winget install --id MiKTeX.MiKTeX -e
        elif command -v choco >/dev/null 2>&1; then
            echo "Detected Windows (Chocolatey). Installing MiKTeX..."
            choco install miktex -y
        else
            echo "Detected Windows without a supported package manager."
            echo "Install MiKTeX manually: https://miktex.org/download"
            exit 1
        fi
        ;;
    *)
        echo "Unknown OS '$os'."
        echo "Install a TeX distribution manually."
        exit 1
        ;;
esac

echo "Installation complete. Verify with: pdflatex --version"
