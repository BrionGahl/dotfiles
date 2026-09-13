local vars = require("config.variables")
local uwsm = vars.uwsm
local mainMod = vars.mainMod

local fullscreenLockoutBinds = {}
local function riskyBind(keys, dispatcher, opts)
    local b = hl.bind(keys, dispatcher, opts)
    table.insert(fullscreenLockoutBinds, b)
    return b
end

hl.on("window.fullscreen", function()
    local win = hl.get_active_window()
    local isFullscreen = win ~= nil and win.fullscreen ~= 0
    for _, b in ipairs(fullscreenLockoutBinds) do
        b:set_enabled(not isFullscreen)
    end
end)

-- Open a terminal (Alacritty)
hl.bind(mainMod .. " + " .. "RETURN", hl.dsp.exec_cmd(uwsm .. "alacritty"))

-- Open the app launcher (Wofi, drun mode). Wofi has no built-in single-
-- instance guard, so repeated SUPER+D presses would otherwise stack up a
-- new window each time; skip the launch if one's already running.
hl.bind(mainMod .. " + " .. "D", hl.dsp.exec_cmd("pgrep -x wofi > /dev/null || " .. uwsm .. "wofi --show drun"))

-- Close the currently focused window
riskyBind(mainMod .. " + " .. "Q", hl.dsp.window.close())

-- Toggle the focused window between floating and tiled
riskyBind(mainMod .. " + " .. "SPACE", hl.dsp.window.float({ action = "toggle" }))

-- Toggle fullscreen for the focused window
riskyBind(mainMod .. " + " .. "F", hl.dsp.window.fullscreen())

-- Power menu (lock / logout / suspend / hibernate / reboot / shutdown)
riskyBind(mainMod .. " + SHIFT + " .. "E", hl.dsp.exec_cmd(uwsm .. "powermenu"))

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

-- Send the focused window to workspaces 1-5
for i = 1, 5 do
    riskyBind(mainMod .. " + SHIFT + " .. tostring(i), hl.dsp.window.move({ workspace = i }))
end

-- Cycle focus to the next/previous existing workspace by scrolling
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize the focused window by holding SUPER and dragging with the
-- left/right mouse button (mouse:272 = left, mouse:273 = right)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

-- Lock the screen on demand (hypridle also does this automatically on timeout)
riskyBind(mainMod .. " + CTRL + " .. "L", hl.dsp.exec_cmd(uwsm .. "hyprlock"))

-- Reload Hyprland, mako, and waybar configs without restarting the session.
-- mako reloads in place via its IPC socket; waybar has no reload IPC, so it
-- gets killed and relaunched instead.
hl.bind(mainMod .. " + SHIFT + " .. "R", hl.dsp.exec_cmd("hyprctl reload; makoctl reload; pkill waybar; " .. uwsm .. "waybar"))

-- Media keys: volume/mic via wpctl, playback via playerctl (MPRIS). "locked"
-- lets these work even from the lock screen; "repeating" lets holding the
-- volume keys ramp continuously.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
