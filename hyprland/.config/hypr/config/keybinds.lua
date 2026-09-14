local vars = require("config.variables")
local uwsm = vars.uwsm
local mainMod = vars.mainMod

-- Binds that should keep working no matter what submap is active (see the
-- "restricted" submap below). Everything bound with plain hl.bind stays
-- scoped to the root submap and goes dead while restricted.
local function bind(keys, dispatcher, opts)
    opts = opts or {}
    opts.submap_universal = true
    return hl.bind(keys, dispatcher, opts)
end

-- While the focused window is fullscreen, drop into a submap that only
-- keeps the binds marked submap_universal (via `bind` above) alive. Every
-- plain hl.bind below (close/float/fullscreen-toggle/powermenu/move/lock)
-- goes dead until fullscreen ends, so a stray keypress can't yank you out
-- of a game or video.
hl.on("window.fullscreen", function()
    local win = hl.get_active_window()
    local isFullscreen = win ~= nil and win.fullscreen ~= 0
    hl.dispatch(hl.dsp.submap(isFullscreen and "restricted" or "reset"))
end)

-- Registers the "restricted" submap name (Hyprland refuses to switch to a
-- submap with no binds registered under it) and doubles as a manual escape
-- hatch if a fullscreen exit is ever missed.
hl.define_submap("restricted", function()
    hl.bind(mainMod .. " + " .. "F", hl.dsp.submap("reset"))
end)

-- Open a terminal (Alacritty)
bind(mainMod .. " + " .. "RETURN", hl.dsp.exec_cmd(uwsm .. "alacritty"))

-- Open the app launcher (Wofi, drun mode). Wofi has no built-in single-
-- instance guard, so repeated SUPER+D presses would otherwise stack up a
-- new window each time; skip the launch if one's already running.
bind(mainMod .. " + " .. "D", hl.dsp.exec_cmd("pgrep -x wofi > /dev/null || " .. uwsm .. "wofi --show drun"))

-- Close the currently focused window
hl.bind(mainMod .. " + " .. "Q", hl.dsp.window.close())

-- Toggle the focused window between floating and tiled
hl.bind(mainMod .. " + " .. "SPACE", hl.dsp.window.float({ action = "toggle" }))

-- Toggle fullscreen for the focused window
hl.bind(mainMod .. " + " .. "F", hl.dsp.window.fullscreen())

-- Power menu (lock / logout / suspend / hibernate / reboot / shutdown)
hl.bind(mainMod .. " + SHIFT + " .. "E", hl.dsp.exec_cmd(uwsm .. "powermenu"))

-- Move focus to the window on the left/right/up/down
bind(mainMod .. " + " .. "H", hl.dsp.focus({ direction = "l" }))
bind(mainMod .. " + " .. "L", hl.dsp.focus({ direction = "r" }))
bind(mainMod .. " + " .. "K", hl.dsp.focus({ direction = "u" }))
bind(mainMod .. " + " .. "J", hl.dsp.focus({ direction = "d" }))

-- Move the focused window left/right/up/down within the layout
hl.bind(mainMod .. " + SHIFT + " .. "H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + " .. "L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + " .. "K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + " .. "J", hl.dsp.window.move({ direction = "d" }))

-- Switch to workspaces 1-5
for i = 1, 5 do
    bind(mainMod .. " + " .. tostring(i), hl.dsp.focus({ workspace = i }))
end

-- Send the focused window to workspaces 1-5
for i = 1, 5 do
    hl.bind(mainMod .. " + SHIFT + " .. tostring(i), hl.dsp.window.move({ workspace = i }))
end

-- Cycle focus to the next/previous existing workspace by scrolling
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize the focused window by holding SUPER and dragging with the
-- left/right mouse button (mouse:272 = left, mouse:273 = right)
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots
bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

-- Lock the screen on demand (hypridle also does this automatically on timeout)
hl.bind(mainMod .. " + CTRL + " .. "L", hl.dsp.exec_cmd(uwsm .. "hyprlock"))

-- Reload Hyprland, mako, and waybar configs without restarting the session.
-- mako reloads in place via its IPC socket; waybar has no reload IPC, so it
-- gets killed and relaunched instead.
bind(mainMod .. " + SHIFT + " .. "R", hl.dsp.exec_cmd("hyprctl reload; makoctl reload; pkill waybar; " .. uwsm .. "waybar"))

-- Media keys: volume/mic via wpctl, playback via playerctl (MPRIS). "locked"
-- lets these work even from the lock screen; "repeating" lets holding the
-- volume keys ramp continuously.
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
