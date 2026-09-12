-- ============================
-- MONITORS
-- ============================

-- LG UltraGear 27" (2560x1440@144), left monitor
hl.monitor({
    output   = "DP-5",
    mode     = "2560x1440@143.97",
    position = "0x0",
    scale    = 1,
})

-- LG UltraWide 34" (3440x1440@160), right monitor
hl.monitor({
    output   = "DP-6",
    mode     = "3440x1440@159.96",
    position = "2560x0",
    scale    = 1,
})


-- ============================
-- ENVIRONMENT VARIABLES
-- ============================
 
-- Force NVIDIA VAAPI driver for hardware video decode/encode
hl.env("LIBVA_DRIVER_NAME", "nvidia")
 
-- Tell GLX which vendor library to use (required for NVIDIA + Wayland)
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
 
-- Let Electron apps (Discord, VSCode, Slack, etc.) auto-detect Wayland vs X11
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
 
 
-- ============================
-- VARIABLES
-- ============================
 
-- Prefix to launch apps scoped under UWSM (proper systemd session tracking)
local uwsm = "uwsm app -- "
 
-- Main modifier key used across all keybinds below
local mainMod = "SUPER"
 
 
-- ============================
-- AUTOSTART
-- ============================
 
hl.on("hyprland.start", function()
    -- Launch the status bar (clock, workspaces, tray, etc.) on session start
    hl.exec_cmd(uwsm .. "waybar")
    -- Launch the idle functionality via the hypridle.conf
    hl.exec_cmd(uwsm .. "hypridle")
    -- Polkit (binary lives in /usr/libexec, not on $PATH)
    hl.exec_cmd(uwsm .. "/usr/libexec/hyprpolkitagent")
    -- Notification Daemon: not launched here. mako ships its own systemd
    -- unit + D-Bus activation (org.freedesktop.Notifications), so starting
    -- it manually here raced with D-Bus activation and made mako.service
    -- fail with "Failed to acquire service name: File exists".
    -- Wallpaper
    hl.exec_cmd(uwsm .. "hyprpaper")

end)
 
 
-- ============================
-- KEYBINDS
-- ============================

-- Binds registered through riskyBind() get auto-disabled while any window is
-- fullscreen (see the "window.fullscreen" listener at the end of this
-- section), so a stray SUPER-press mid-game can't close the window, kick it
-- out of fullscreen, shuffle the tiling, or log the session out.
local fullscreenLockoutBinds = {}
local function riskyBind(keys, dispatcher, opts)
    local b = hl.bind(keys, dispatcher, opts)
    table.insert(fullscreenLockoutBinds, b)
    return b
end

-- Open a terminal (Alacritty)
hl.bind(mainMod .. " + " .. "RETURN", hl.dsp.exec_cmd(uwsm .. "alacritty"))

-- Open the app launcher (Wofi, drun mode)
hl.bind(mainMod .. " + " .. "D", hl.dsp.exec_cmd(uwsm .. "wofi --show drun"))

-- Close the currently focused window
riskyBind(mainMod .. " + " .. "Q", hl.dsp.window.close())

-- Toggle the focused window between floating and tiled
riskyBind(mainMod .. " + " .. "SPACE", hl.dsp.window.float({ action = "toggle" }))

-- Toggle fullscreen for the focused window
riskyBind(mainMod .. " + " .. "F", hl.dsp.window.fullscreen())

-- Logout / Shutdown
riskyBind(mainMod .. " + SHIFT + " .. "E", hl.dsp.exec_cmd(uwsm .. "wlogout"))

-- Move focus to the window on the left/right/up/down
hl.bind(mainMod .. " + " .. "H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + " .. "L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + " .. "K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + " .. "J", hl.dsp.focus({ direction = "d" }))

-- Move the focused window left/right/up/down within the layout
riskyBind(mainMod .. " + SHIFT + " .. "H", hl.dsp.window.move({ direction = "l" }))
riskyBind(mainMod .. " + SHIFT + " .. "L", hl.dsp.window.move({ direction = "r" }))
riskyBind(mainMod .. " + SHIFT + " .. "K", hl.dsp.window.move({ direction = "u" }))
riskyBind(mainMod .. " + SHIFT + " .. "J", hl.dsp.window.move({ direction = "d" }))

-- Switch to workspaces 1-5
for i = 1, 5 do
    hl.bind(mainMod .. " + " .. tostring(i), hl.dsp.focus({ workspace = i }))
end

-- Screenshots
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

-- Disable the risky binds above whenever the active window goes fullscreen,
-- and restore them the moment nothing is fullscreen anymore.
hl.on("window.fullscreen", function()
    local win = hl.get_active_window()
    local isFullscreen = win ~= nil and win.fullscreen ~= 0
    for _, b in ipairs(fullscreenLockoutBinds) do
        b:set_enabled(not isFullscreen)
    end
end)


-- ============================
-- WINDOW RULES
-- ============================

-- Windows/Proton game binaries (launched via Heroic, Steam, etc.) always get
-- a window class matching their .exe name (e.g. "wow.exe"), unlike native
-- Linux/Wayland apps. Pin them all to the ultrawide (DP-6) regardless of
-- which monitor/workspace is focused when they're launched.
--
-- "monitor" is a static effect (applied once, at window creation), so it
-- must be matched against initial_class rather than class -- Wine/Proton
-- windows often don't have their final class set until just after creation,
-- and a static effect won't re-evaluate once that rename happens.
hl.window_rule({
    name    = "games-on-ultrawide",
    match   = { initial_class = ".*\\.exe$" },
    monitor = "DP-6",
})
