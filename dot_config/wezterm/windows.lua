local launch_menu = {}

table.insert(launch_menu, {
	label = 'PowerShell',
	args = { 'powershell.exe', '-NoLogo' },
})

-- Find installed visual studio version(s) and add their compilation
-- environment command prompts to the menu
for _, vsvers in
ipairs(
	wezterm.glob('Microsoft Visual Studio/20*', 'C:/Program Files (x86)')
)
do
	local year = vsvers:gsub('Microsoft Visual Studio/', '')
	table.insert(launch_menu, {
		label = 'x64 Native Tools VS ' .. year,
		args = {
			'cmd.exe',
			'/k',
			'C:/Program Files (x86)/'
			.. vsvers
			.. '/BuildTools/VC/Auxiliary/Build/vcvars64.bat',
		},
	})
end

-- TODO: MSYS2

config.launch_menu = launch_menu