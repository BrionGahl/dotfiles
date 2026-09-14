hl.config({
    decoration = {
        rounding = 12,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        blur = {
            enabled = true,
            size    = 4,
            passes  = 2,
            new_optimizations = true,
        },
    },

    general = {
        gaps_in = 5,
        gaps_out = 15,
    },

    input = {
        kb_layout = "us",
    },

    misc = {
        disable_splash_rendering = true,
        disable_hyprland_logo    = true,
        force_default_wallpaper  = 0,
    },
})

hl.window_rule({
    name    = "games-on-ultrawide",
    match   = { initial_class = ".*\\.exe$" },
    monitor = "DP-6",
})

hl.layer_rule({
    name         = "waybar-blur",
    match        = { namespace = "waybar" },
    blur         = true,
    blur_popups  = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name         = "mako-blur",
    match        = { namespace = "notifications" },
    blur         = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name         = "wofi-blur",
    match        = { namespace = "wofi" },
    blur         = true,
    ignore_alpha = 0.2,
})

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "myBezier", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "myBezier", style = "popin 80%" })
hl.animation({ leaf = "layers", enabled = true, speed = 5, bezier = "myBezier", style = "fade" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 5, bezier = "myBezier", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 5, bezier = "myBezier", style = "fade" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "myBezier" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 5, bezier = "myBezier", style = "fade" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 5, bezier = "myBezier", style = "fade" })
