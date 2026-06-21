-- HyprGlass - Liquid Glass visual effects
if hl.plugin.hyprglass then
    local hg = hl.plugin.hyprglass

    hg.config({
        enabled = false, -- currently disables it cuz artifacts
        default_theme = "dark",
        default_preset = "glass",
        tint_color = 0x8899aa22,
        brightness = 0.9,
        dark = { brightness = 0.82 },
        light = { adaptive_boost = 0.6 },
        layers = { enabled = 1 },
    })

    hg.layer("noctalia-wallpaper", { exclude = true })
    hg.layer("noctalia-desktop-widget", { exclude = true })
    hg.layer("noctalia-bar-default", { exclude = true })
    hg.layer("noctalia-dock", { exclude = true })
    hg.layer("noctalia-attached-panel", { exclude = true })
    hg.layer("noctalia-panel", { exclude = true })

    hg.preset("glass", {
        blur_strength = 3.0,
        blur_iterations = 3,
        edge_thickness = 0.015,
        refraction_strength = 14.0,
        chromatic_aberration = 0.5,
        fresnel_strength = 0.8,
        specular_strength = 0.8,
        glass_opacity = 1.0,
        tint_color = 0xeeeeff44,
    })
end
