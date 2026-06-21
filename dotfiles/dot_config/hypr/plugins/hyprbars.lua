-- hyprbars - macOS-style title bars with traffic-light buttons
-- Known limitation: hyprbars can't detect Wayland xdg-decoration (CSD),
-- so bars appear on ALL windows including CSD apps (double-bar).
-- hyprbars:no_bar window rules can selectively disable per app if needed.
if hl.plugin.hyprbars then
    local hb = hl.plugin.hyprbars

    hl.config({
        plugin = {
            hyprbars = {
                bar_height = 28,
                bar_blur = false, -- :sob: this is disabled by hyprglass
                bar_part_of_window = true,
                -- bar_color = "rgba(fefefeff)",
                --
                bar_precedence_over_border = true,
                bar_padding = 10,
                bar_title_enabled = true,
                bar_text_size = 14,
                bar_text_weight = "medium",
                bar_text_align = "center",
                bar_buttons_alignment = "left",
                inactive_button_color = "rgba(aaaaaaff)",
                icon_on_hover = true,
                on_double_click = "hyprctl dispatch 'hl.dsp.window.fullscreen()'",
            },
        },
    })

    -- macOS traffic-light buttons (red / yellow / green / blue)
    hb.add_button({
        icon = "x",
        size = 14,
        bg_color = "rgb(ff5f56)",
        fg_color = "rgba(ffffff88)",
        action = "hyprctl dispatch 'hl.dsp.window.close()'",
    })
    hb.add_button({
        icon = "-",
        size = 14,
        bg_color = "rgb(ffbd2e)",
        fg_color = "rgb(ffffff)",
        -- movetoworkspacesilent: moves to special without focus change (no freeze)
        action = "hyprctl dispatch 'hl.dsp.window.move({ workspace = \"special\" })'",
    })
    hb.add_button({
        icon = "/",
        size = 14,
        bg_color = "rgb(27c93f)",
        fg_color = "rgb(ffffff)",
        action = "hyprctl dispatch 'hl.dsp.window.fullscreen()'",
    })
    hb.add_button({
        icon = "=",
        size = 14,
        bg_color = "rgb(0044cc)",
        fg_color = "rgb(ffffff)",
        action = "hyprctl dispatch 'hl.dsp.window.float({ action = \"unset\" })'",
    })
end
