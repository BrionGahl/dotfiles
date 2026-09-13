-- Force NVIDIA VAAPI driver for hardware video decode/encode
hl.env("LIBVA_DRIVER_NAME", "nvidia")

-- Tell GLX which vendor library to use (required for NVIDIA + Wayland)
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- Let Electron apps (Discord, VSCode, Slack, etc.) auto-detect Wayland vs X11
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Theme GTK3 apps to match the Dracula look used everywhere else in this
-- session (alacritty/waybar/wofi/mako). Scoped to this env var rather than
-- editing the shared ~/.config/gtk-3.0/settings.ini, since that file is also
-- read by the KDE/Plasma session on this machine and would re-theme it too.
-- GTK4/libadwaita apps mostly ignore GTK_THEME and are unaffected either way.
hl.env("GTK_THEME", "Dracula")
