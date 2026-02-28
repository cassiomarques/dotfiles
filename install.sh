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

# Repositories that need Ruby development setup (ruby-lsp, ctags, Ruby PATH).
# Add new entries to enable Ruby tooling for other Codespace repos.
RUBY_REPOS=(
  /workspaces/github
  # /workspaces/another-ruby-repo
)

RUBY_REPO=""
for repo in "${RUBY_REPOS[@]}"; do
  if [[ -d "$repo" ]]; then
    RUBY_REPO="$repo"
    break
  fi
done

# --- Update package index once for all apt installs below ---
sudo apt-get update -qq

# --- Neovim (nightly/prerelease via AppImage — required for LazyVim 0.12+ features) ---
NVIM_REQUIRED_MAJOR=0
NVIM_REQUIRED_MINOR=12
needs_nvim_install=true

if command -v nvim &>/dev/null; then
  nvim_version=$(nvim --version 2>/dev/null | head -1 | grep -oP '\d+\.\d+' | head -1)
  nvim_major=$(echo "$nvim_version" | cut -d. -f1)
  nvim_minor=$(echo "$nvim_version" | cut -d. -f2)
  if [ "$nvim_major" -gt "$NVIM_REQUIRED_MAJOR" ] 2>/dev/null || \
     { [ "$nvim_major" -eq "$NVIM_REQUIRED_MAJOR" ] && [ "$nvim_minor" -ge "$NVIM_REQUIRED_MINOR" ]; } 2>/dev/null; then
    echo "==> Neovim already meets requirement (>= ${NVIM_REQUIRED_MAJOR}.${NVIM_REQUIRED_MINOR}): $(nvim --version | head -1)"
    needs_nvim_install=false
  else
    echo "==> Neovim $(nvim --version | head -1) is too old, upgrading to nightly..."
  fi
fi

if [ "$needs_nvim_install" = true ]; then
  echo "==> Installing Neovim nightly (prerelease) via AppImage..."
  # Use neovim-releases repo (built for older glibc, compatible with Ubuntu 20.04)
  curl -fsSL -o /tmp/nvim.appimage \
    https://github.com/neovim/neovim-releases/releases/download/nightly/nvim-linux-x86_64.appimage
  chmod u+x /tmp/nvim.appimage
  cd /tmp && ./nvim.appimage --appimage-extract
  sudo rm -rf /squashfs-root
  sudo mv /tmp/squashfs-root /squashfs-root
  sudo ln -sf /squashfs-root/AppRun /usr/bin/nvim
  rm -f /tmp/nvim.appimage
  echo "    Installed: $(nvim --version 2>/dev/null | head -1)"
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

# --- tree-sitter CLI (needed by nvim-treesitter; mason's binary requires newer glibc) ---
if ! command -v tree-sitter &>/dev/null; then
  echo "==> Installing tree-sitter CLI via cargo (this may take a few minutes)..."
  cargo install tree-sitter-cli
  sudo ln -sf "$HOME/.cargo/bin/tree-sitter" /usr/local/bin/tree-sitter
else
  echo "==> tree-sitter CLI already installed"
fi

# --- Ruby development setup (only for repos listed in RUBY_REPOS) ---
if [[ -n "$RUBY_REPO" ]]; then
  echo "==> Setting up Ruby development tools for ${RUBY_REPO}..."

  # Determine which Ruby to use: project vendored Ruby if available, system Ruby otherwise
  RUBY_SHA=$("$RUBY_REPO/config/ruby-version" 2>/dev/null || true)
  PROJECT_RUBY_BIN="$RUBY_REPO/vendor/ruby/$RUBY_SHA/bin"
  if [[ -n "$RUBY_SHA" && -x "$PROJECT_RUBY_BIN/ruby" ]]; then
    RUBY_BIN="$PROJECT_RUBY_BIN"
    echo "    Using project Ruby: $($RUBY_BIN/ruby --version)"
  else
    RUBY_BIN="$(dirname "$(command -v ruby)")"
    echo "    Project Ruby not found, using system Ruby: $(ruby --version)"
  fi

  # ruby-lsp gem
  echo "    Installing ruby-lsp gem..."
  PATH="$RUBY_BIN:$PATH" gem install ruby-lsp --no-document
  # Wrapper script so ruby-lsp uses the correct Ruby regardless of shell PATH
  sudo tee /usr/local/bin/ruby-lsp > /dev/null <<WRAPPER
#!/bin/bash
RUBY_SHA=\$($RUBY_REPO/config/ruby-version 2>/dev/null || true)
RBIN="$RUBY_REPO/vendor/ruby/\$RUBY_SHA/bin"
if [[ -x "\$RBIN/ruby" ]]; then
  export PATH="\$RBIN:\$PATH"
  exec "\$RBIN/ruby-lsp" "\$@"
else
  exec ruby-lsp "\$@"
fi
WRAPPER
  sudo chmod +x /usr/local/bin/ruby-lsp
  echo "    ruby-lsp installed: $(ruby-lsp --version 2>&1 || true)"

  # universal-ctags for fast navigation while ruby-lsp indexes
  if ! command -v ctags &>/dev/null; then
    echo "    Installing universal-ctags..."
    sudo apt-get install -y universal-ctags
  fi

  # Generate ctags in background
  echo "    Generating ctags (background)..."
  (cd "$RUBY_REPO" && ctags -R \
    --languages=Ruby \
    --exclude=vendor/ruby \
    --exclude=vendor/cache \
    --exclude=node_modules \
    --exclude=sorbet \
    --exclude=tmp \
    --exclude=log \
    --exclude=db \
    -f tags \
    app lib config packages vendor/gems &) 2>/dev/null

  # Add project Ruby to shell PATH (only if project Ruby exists)
  if [[ -n "$RUBY_SHA" && -x "$PROJECT_RUBY_BIN/ruby" ]]; then
    RUBY_PROFILE_MARKER="# dotfiles: Ruby PATH for $RUBY_REPO"
    if ! grep -q "$RUBY_PROFILE_MARKER" "$HOME/.bashrc" 2>/dev/null; then
      echo "    Adding project Ruby to shell PATH..."
      cat >> "$HOME/.bashrc" <<BASHEOF

$RUBY_PROFILE_MARKER
if [ -d "$RUBY_REPO" ]; then
  export RAILS_ROOT="$RUBY_REPO"
  RUBY_SHA=\$("\$RAILS_ROOT/config/ruby-version")
  export PATH="\$RAILS_ROOT/vendor/ruby/\$RUBY_SHA/bin:\$RAILS_ROOT/bin:\$PATH"
fi
BASHEOF
    fi
  fi

  echo "    Ruby development setup complete."
else
  echo "==> Not a Ruby repo — skipping Ruby development setup"
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
