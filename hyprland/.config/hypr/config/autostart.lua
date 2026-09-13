local uwsm = require("config.variables").uwsm

hl.on("hyprland.start", function()
    -- Launch the status bar (clock, workspaces, tray, etc.) on session start
    hl.exec_cmd(uwsm .. "waybar")
    -- Launch the idle functionality via the hypridle.conf
    hl.exec_cmd(uwsm .. "hypridle")
    -- Polkit (binary lives in /usr/libexec, not on $PATH)
    hl.exec_cmd(uwsm .. "/usr/libexec/hyprpolkitagent")
    -- Wallpaper
    hl.exec_cmd(uwsm .. "hyprpaper")
end)
