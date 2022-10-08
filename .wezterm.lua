local wezterm = require("wezterm")

function strip_home_name(text)
	local username = os.getenv("USER")
	clean_text = text:gsub("/home/" .. username, "~")
	return clean_text
end

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
	end

	local clean_title = strip_home_name(tab.active_pane.title)
	return zoomed .. index .. clean_title
end)

return {
	default_prog = { "wsl.exe", "--cd", "~" },
	color_scheme = "tokyonight-storm",
	-- color_scheme = "nord",
	hide_tab_bar_if_only_one_tab = true,
	use_ime = true,
	-- window_padding = { left = 10, right = 10, top = 10, bottom = 5 },
	window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
	tab_max_width = 10,
}
