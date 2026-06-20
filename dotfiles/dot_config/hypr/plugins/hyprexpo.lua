-- hyprexpo - expose-style workspace overview grid
if hl.plugin.hyprexpo then
  hl.config({
    plugin = {
      hyprexpo = {
        columns = 3,
        gaps_in = 5,
        gaps_out = 0,
        bg_col = "rgb(111111)",
        workspace_method = "center current",
        gesture_distance = 200,
        cancel_key = "escape",
        show_cursor = 1,
        label_enable = 1,
        label_show = "always",
        label_text_mode = "token",
        label_token_map = "1,2,3,4,5,6,7,8,9,0",
        keynav_enable = 1,
        keynav_wrap_h = 1,
        keynav_wrap_v = 1,
      },
    },
  })

  -- 三指上滑 → 切換 overview
  hl.plugin.hyprexpo.gesture({
    fingers = 3,
    direction = "up",
    action = "expo",
  })

  -- Super + Tab → toggle
  hl.bind("SUPER + TAB", function()
    hl.plugin.hyprexpo.expo("toggle")
  end)
  hl.bind("SUPER + SHIFT + TAB", function()
    hl.plugin.hyprexpo.expo("on")
  end)
  hl.bind("SUPER + Escape", function()
    hl.plugin.hyprexpo.expo("cancel")
  end)
end
