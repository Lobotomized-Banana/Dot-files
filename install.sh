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
for pkg in hypr waybar rofi swaync scripts firefox plasma opencode; do
  echo "stow $pkg"
  stow -v -R -t "$HOME" "$pkg"
done

# wallpaper -> ~/Pictures
mkdir -p ~/Pictures
cp -v wallpapers/purple-glow-3840x1080.png ~/Pictures/ || true

# Plasma: apply scheme + accent + icons (file writes work outside Plasma too)
plasma-apply-colorscheme PurpleSquircle >/dev/null 2>&1 || true
kwriteconfig6 --file kdeglobals --group General --key AccentColor "91,12,166" || true
kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Dark || true
# NOTE: Plasma wallpaper can't be set headlessly; inside a Plasma session run:
#   plasma-apply-wallpaperimage ~/Pictures/purple-glow-3840x1080.png

# SDDM greeter theme (system paths, needs root - not stowable)
if [ -d "$DOTFILES/sddm/purple-squircle" ]; then
  echo "installing SDDM theme (sudo)"
  sudo rm -rf /usr/share/sddm/themes/purple-squircle
  sudo cp -r "$DOTFILES/sddm/purple-squircle" /usr/share/sddm/themes/purple-squircle
  sudo chmod -R a+rX /usr/share/sddm/themes/purple-squircle
  printf '[Theme]\nCurrent=purple-squircle\n' | sudo tee /etc/sddm.conf.d/purple.conf >/dev/null
fi

chmod +x ~/.local/bin/rofi-powermenu ~/.local/bin/screenshot-* ~/.local/bin/wallpaper-set 2>/dev/null || true

# 4. reload
pkill -x waybar 2>/dev/null || true
(sleep 0.3; waybar & swaync & hypridle &) 2>/dev/null || true
~/.local/bin/wallpaper-set ~/Pictures/purple-glow-3840x1080.png || true
hyprctl reload 2>/dev/null || echo "run 'hyprctl reload' inside Hyprland"

echo "done. Alacritty theme is PREVIEW ONLY:"
echo "  alacritty --config-file ~/.config/alacritty/alacritty-purple-preview.toml"
