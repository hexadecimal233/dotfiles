-- TEMP: hexadecimal233 fork w/ V2 API (upstream savonovv v0.3.1 crashed on 0.55.4 — uses V1 API)
if hl.plugin["hypr-kinetic-scroll"] then
    hl.config({
        plugin = {
            ["kinetic-scroll"] = {
                enabled = true,
                decel = 12.0,

                interval_ms = 8,
                delta_multiplier = 1.25,
                disable_in_browser = true,
                stop_on_target_change = true,
                stop_on_touchpad_gesture = true,
                stop_delay_ms = 20,
                stop_on_click = false,
                stop_on_focus = false,
                debug = false,
            }
        }
    })
end
