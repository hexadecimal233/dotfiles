-- hypr-dynamic-cursors - shake to find cursor
if hl.plugin.dynamic_cursors then
    hl.config({
        plugin = {
            dynamic_cursors = {
                enabled = true,
                mode = "none", -- no tilt/rotate/stretch, just shake to find
                shake = {
                    enabled = true,
                    threshold = 6.0,
                    base = 6.0,
                    influence = 0.0,
                    speed = 0.0,
                    timeout = 400,
                },
                hyprcursor = { enabled = true, nearest = 1 },
            }
        }
    })
end
