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
  plasma/.local/share/color-schemes/PurpleSquircle.colors
  opencode/.config/opencode/{cli.json,themes/purple-squircle.json}
  opencode/.config/opencode/webui/purple-squircle-webui.css (web UI, see below)
```

## OpenCode web UI theme

The TUI theme (`themes/`) does not cover the browser UI. The web app
(`opencode web` / desktop app) loads custom CSS from localStorage
(`opencode-theme-id` + `opencode-theme-css-dark`, see `oc-theme-preload.js`):

1. Run on a FIXED port (localStorage is per-origin, random ports lose it):
   `opencode web --port 4096`
2. In the web UI, open DevTools console (F12) and paste:
   `fetch('https://raw.githubusercontent.com/Lobotomized-Banana/Dot-files/main/opencode/.config/opencode/webui/purple-squircle-webui.css').then(r=>r.text()).then(css=>{localStorage.setItem('opencode-theme-id','purple-squircle');localStorage.setItem('opencode-theme-css-dark',css);localStorage.setItem('opencode-theme-css-light',css);location.reload();});`
3. The desktop app needs the same snippet once in its own DevTools.
  scripts/.local/bin/{rofi-powermenu,screenshot-full,screenshot-area,wallpaper-set}
  wallpapers/purple-glow-3840x1080.png
  sddm/purple-squircle/{Main.qml,metadata.desktop,theme.conf,background.png}
  install.sh  # also installs SDDM theme to /usr/share/sddm (sudo, not stowable)
```

## SDDM

`install.sh` copies the theme to `/usr/share/sddm/themes/purple-squircle`
and sets `Current=purple-squircle` in `/etc/sddm.conf.d/purple.conf`
(sorts after KDE's `kde_settings.conf`, so it wins; breeze stays installed).
Revert: `sudo rm /etc/sddm.conf.d/purple.conf` (falls back to breeze).

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
