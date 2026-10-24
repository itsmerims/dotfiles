local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15.0
config.window_background_opacity = 0.9
config.macos_window_background_blur = 50
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.default_prog = { 'powershell.exe', '-NoLogo' }
config.allow_win32_input_mode = false

-- Explicitly map standard paste commands
config.keys = {
  { key = 'v', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 'Insert', mods = 'SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
}

-- Dim unfocused windows so the focused one is obvious at a glance.
local UNFOCUSED_FOREGROUND_TEXT_HSB = { hue = 1.0, saturation = 0.25, brightness = 0.45 }
local UNFOCUSED_WINDOW_BACKGROUND_OPACITY = 0.62

-- get_config_overrides() hands back a copy, so the current value is never the
-- same table we last stored; compare the fields instead of the identity.
local function same_text_hsb(actual, expected)
	if actual == nil or expected == nil then
		return actual == expected
	end
	return actual.hue == expected.hue
		and actual.saturation == expected.saturation
		and actual.brightness == expected.brightness
end

wezterm.on("window-focus-changed", function(window)
    local overrides = window:get_config_overrides() or {}
    local text_hsb, opacity
    
    if not window:is_focused() then
        text_hsb = UNFOCUSED_FOREGROUND_TEXT_HSB
        opacity = UNFOCUSED_WINDOW_BACKGROUND_OPACITY
    else
        text_hsb = nil
        opacity = config.window_background_opacity 
    end

    if same_text_hsb(overrides.foreground_text_hsb, text_hsb) and overrides.window_background_opacity == opacity then
        return
    end

    overrides.foreground_text_hsb = text_hsb
    overrides.window_background_opacity = opacity
    window:set_config_overrides(overrides)
    
    -- FIX: Return the configuration overrides table to the window
    return overrides
end)


return config
