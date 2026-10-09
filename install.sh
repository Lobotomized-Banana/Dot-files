#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

echo "== purple squircle dotfiles =="
echo "dotfiles: $DOTFILES"

# 1. packages (Arch)
if command -v pacman >/dev/null; then
  sudo pacman -S --needed --noconfirm waybar rofi hyprpaper swaync grim slurp hypridle stow ttf-jetbrains-mono-nerd otf-font-awesome brightnessctl playerctl pavucontrol || true
fi

# 2. backup conflicting files
backup() {
  if [ -e "$HOME/$1" ] && [ ! -L "$HOME/$1" ]; then
    mkdir -p "$HOME/.config-backup-$(date +%Y%m%d)"
    echo "backup $1 -> ~/.config-backup-$(date +%Y%m%d)/"
    mv "$HOME/$1" "$HOME/.config-backup-$(date +%Y%m%d)/" 2>/dev/null || cp -r "$HOME/$1" "$HOME/.config-backup-$(date +%Y%m%d)/"
  fi
}

# 3. stow (skip alacritty until preview approved)
for pkg in hypr waybar rofi swaync scripts firefox; do
  echo "stow $pkg"
  stow -v -R -t "$HOME" "$pkg"
done

# wallpaper -> ~/Pictures
mkdir -p ~/Pictures
cp -v wallpapers/purple-glow-3840x1080.png ~/Pictures/ || true

chmod +x ~/.local/bin/rofi-powermenu ~/.local/bin/screenshot-* ~/.local/bin/wallpaper-set 2>/dev/null || true

# 4. reload
pkill -x waybar 2>/dev/null || true
(sleep 0.3; waybar & swaync & hypridle &) 2>/dev/null || true
~/.local/bin/wallpaper-set ~/Pictures/purple-glow-3840x1080.png || true
hyprctl reload 2>/dev/null || echo "run 'hyprctl reload' inside Hyprland"

echo "done. Alacritty theme is PREVIEW ONLY:"
echo "  alacritty --config-file ~/.config/alacritty/alacritty-purple-preview.toml"
