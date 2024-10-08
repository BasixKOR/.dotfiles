wezterm = require 'wezterm'
config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
	require 'windows'
end

config.font = wezterm.font_with_fallback({
	'CaskaydiaCove Nerd Font',
	'D2Coding',
})

config.native_macos_fullscreen_mode = true

return config
