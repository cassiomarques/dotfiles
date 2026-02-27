#!/bin/bash
# install.sh — Codespace dotfiles installer
# Auto-detected by GitHub Codespaces. Does nothing outside a Codespace.

set -e

if [[ "$CODESPACES" != "true" ]]; then
  echo "ℹ️  Not running inside a GitHub Codespace. Skipping Codespace-specific setup."
  exit 0
fi

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Running Codespace dotfiles installer from ${DOTFILES_DIR}..."

# --- Update package index once for all apt installs below ---
sudo apt-get update -qq

# --- Neovim (nightly/prerelease via AppImage — required for LazyVim 0.12+ features) ---
if command -v nvim &>/dev/null; then
  echo "==> Neovim already installed: $(nvim --version | head -1)"
  echo "    To upgrade, remove /squashfs-root and /usr/bin/nvim, then re-run this script."
else
  echo "==> Installing Neovim nightly (prerelease) via AppImage..."
  curl -fsSL -o /tmp/nvim.appimage \
    https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage
  chmod u+x /tmp/nvim.appimage
  cd /tmp && ./nvim.appimage --appimage-extract
  sudo mv /tmp/squashfs-root /squashfs-root
  sudo ln -sf /squashfs-root/AppRun /usr/bin/nvim
  rm -f /tmp/nvim.appimage
  echo "    Installed: $(nvim --version | head -1)"
fi

# --- tmux ---
if ! command -v tmux &>/dev/null; then
  echo "==> Installing tmux..."
  sudo apt-get install -y tmux
else
  echo "==> tmux already installed: $(tmux -V)"
fi

# --- fd-find (used by Telescope) ---
if ! command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  echo "==> Installing fd-find..."
  sudo apt-get install -y fd-find
else
  echo "==> fd-find already installed"
fi

# --- ripgrep (used by Telescope) ---
if ! command -v rg &>/dev/null; then
  echo "==> Installing ripgrep..."
  sudo apt-get install -y ripgrep
else
  echo "==> ripgrep already installed"
fi

# --- Neovim config (LazyVim) ---
echo "==> Setting up Neovim config (LazyVim)..."
if [ -d "$HOME/.config/nvim" ]; then
  echo "    Backing up existing ~/.config/nvim to ~/.config/nvim.bak"
  rm -rf "$HOME/.config/nvim.bak"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi
mkdir -p "$HOME/.config"
cp -r "${DOTFILES_DIR}/.config/nvim" "$HOME/.config/nvim"

# --- tmux config ---
echo "==> Setting up tmux config (Codespace variant)..."
if [ -f "${DOTFILES_DIR}/.tmux.codespace.conf" ]; then
  cp "${DOTFILES_DIR}/.tmux.codespace.conf" "$HOME/.tmux.conf"
fi

# --- TPM (tmux plugin manager) ---
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "==> Installing TPM (tmux plugin manager)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  echo "==> TPM already installed"
fi

# Install tmux plugins non-interactively
echo "==> Installing tmux plugins via TPM..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || true

echo ""
echo "✅ Codespace dotfiles setup complete!"
echo "   - Neovim + LazyVim: run 'nvim' (plugins install on first launch)"
echo "   - tmux: run 'tmux' to start a session"
