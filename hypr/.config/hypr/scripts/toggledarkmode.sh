#!/usr/bin/env sh
# Daemon to toggle dark mode
# Toggler dark/light theme to gtk and qt

# Setting themes
gtk_theme_light="Adwaita"
gtk_theme_dark="Adwaita-dark"
qt_theme_light=$gtk_theme_light
qt_theme_dark=$gtk_theme_dark

# Get current dark mode preference
# current_dark_mode expected value: 'default', 'prefer-dark', 'prefer-light' 
current_dark_mode=$(gsettings get org.gnome.desktop.interface color-scheme)
current_gtk_theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
# current_qt_theme=$()

# Toggle dark mode
if [ "$current_dark_mode" = "'prefer-dark'" ]; then
    gsettings set org.gnome.desktop.interface color-scheme "'prefer-light'"
    gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme_light

else
    gsettings set org.gnome.desktop.interface color-scheme "'prefer-dark'"
    gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme_dark
fi

