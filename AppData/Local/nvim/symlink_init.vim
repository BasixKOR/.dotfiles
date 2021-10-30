../../../.config/nvim/init.vim

{{/*
	Neovim stores their configuration in AppData/Local on Windows.
	To store them in cannoical location regardless of the platform,
	we simply symlink them to .config/nvim.

	https://github.com/neovim/neovim/blob/master/src/nvim/os/stdpaths.c
*/}}