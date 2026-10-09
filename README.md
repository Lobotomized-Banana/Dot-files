# Purple Squircle dotfiles

Main `#5b0ca6` / accent `#490585`, Apple continuous corners (`rounding_power = 4.0`), blur.

## Layout (GNU Stow)

```
dotfiles/
  hypr/.config/hypr/{hyprland.lua,hyprlock.conf,hypridle.conf,hyprpaper.conf}
  waybar/.config/waybar/{config.jsonc,style.css}
  rofi/.config/rofi/{config.rasi,purple.rasi}
  alacritty/.config/alacritty/alacritty.toml   # PREVIEW ONLY, not stowed yet
  swaync/.config/swaync/{config.json,style.css}
  firefox/.config/mozilla/firefox/<profile>/{user.js,chrome/userChrome.css,chrome/userContent.css}
  scripts/.local/bin/{rofi-powermenu,screenshot-full,screenshot-area,wallpaper-set}
  wallpapers/purple-glow-3840x1080.png
  install.sh
```

## Install

```bash
cd ~/dotfiles
./install.sh
# or manually:
stow -R -t ~ hypr waybar rofi swaync scripts
```

Backups go to `~/.config-backup-YYYYMMDD/`.

## Alacritty preview (not permanent)

```bash
alacritty --config-file ~/.config/alacritty/alacritty-purple-preview.toml
# if you like it:
cp ~/.config/alacritty/alacritty-purple-preview.toml ~/.config/alacritty/alacritty.toml
cd ~/dotfiles && stow -R -t ~ alacritty
```

Live config backup: `~/.alacritty.toml.bak`

## Keys

- `SUPER+Q` alacritty
- `SUPER+R` rofi drun (was hyprlauncher)
- `SUPER+SHIFT+R` rofi run
- `SUPER+L` hyprlock
- `SUPER+SHIFT+E` rofi powermenu
- `Print` / `SUPER+Print` / `SUPER+SHIFT+S` screenshots
- `SUPER+C` close, `SUPER+E` dolphin, `SUPER+V` float

## GitHub

```bash
cd ~/dotfiles
git remote add origin git@github.com:YOURUSER/dotfiles.git
git push -u origin main
```

## Replaced

- `nwg-panel` removed from autostart (still installed, `pkill -x nwg-panel`)
- `swww-daemon` -> `awww-daemon` (awww is installed fork)
