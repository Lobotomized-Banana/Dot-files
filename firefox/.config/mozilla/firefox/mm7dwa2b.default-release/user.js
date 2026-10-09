// Purple Squircle dotfiles - managed by stow (firefox package).
// Enables userChrome/userContent stylesheets and pins dark theme.
// Firefox reads this at startup; restart Firefox to apply.

user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.theme.content-theme", 0);
user_pref("browser.theme.toolbar-theme", 0);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
