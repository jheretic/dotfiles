local wezterm = require("wezterm")
local xcursor_size = nil
local xcursor_theme = nil
local mono_font = nil
local window_font = nil

local success, stdout, stderr = wezterm.run_child_process({"gsettings", "get", "org.gnome.desktop.interface", "cursor-theme"})
if success then
  xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
end

local success, stdout, stderr = wezterm.run_child_process({"gsettings", "get", "org.gnome.desktop.interface", "cursor-size"})
if success then
  xcursor_size = tonumber(stdout)
end

local success, stdout, stderr = wezterm.run_child_process({"gsettings", "get", "org.gnome.desktop.interface", "monospace-font-name"})
if success then
  mono_font = stdout
end

local success, stdout, stderr = wezterm.run_child_process({"gsettings", "get", "org.gnome.desktop.wm.preferences", "titlebar-font"})
if success then
  window_font = stdout
end

return {
	adjust_window_size_when_changing_font_size = false,
  colors = {
    tab_bar = {
      -- The color of the strip that goes along the top of the window
      -- (does not apply when fancy tab bar is in use)
      background = '#0b0022',

      -- The active tab is the one that has focus in the window
      active_tab = {
        -- The color of the background area for the tab
        bg_color = '#2b2042',
        -- The color of the text for the tab
        fg_color = '#c0c0c0',

        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = 'Normal',

        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = 'None',

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = '#1b1032',
        fg_color = '#808080',

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = '#3b3052',
        fg_color = '#909090',
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = '#1b1032',
        fg_color = '#808080',

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
        bg_color = '#3b3052',
        fg_color = '#909090',
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab_hover`.
      },
    },
  },

	color_scheme = "Flat Remix",
	color_schemes = {
		["Flat Remix"] = {
			--background = "#272a34",
			background = "#1f2229",
			foreground = "#ffffff",
			cursor_bg = "#ffffff",
			cursor_fg = "#1f2229",
			cursor_border = "#ffffff",
			ansi = {
				"#1f2229",
				"#d41919",
				"#5ebdab",
				"#fea44c",
				"#367bf0",
				"#9755b3",
				"#49aee6",
				"#e6e6e6",
			},
			brights = {
				"#198388",
				"#ec0101",
				"#47d4b9",
				"#ff8a18",
				"#277fff",
				"#962ac3",
				"#05a1f7",
				"#ffffff",
			},
		},
		["Tokyo Dark"] = {
			background = "#11121d",
			foreground = "#a9b1d6",
			cursor_bg = "#a9b1d6",
			cursor_fg = "#11121d",
			cursor_border = "#a9b1d6",
			ansi = {
				"#32344a",
				"#f7768e",
				"#9ece6a",
				"#e0af68",
				"#7aa2f7",
				"#ad8ee6",
				"#449dab",
				"#787c99",
			},
			brights = {
				"#444b6a",
				"#ff7a93",
				"#b9f27c",
				"#ff9e64",
				"#7da6ff",
				"#bb9af7",
				"#0db9d7",
				"#acb0d0",
			},
		},
		["Sonokai Shusia"] = {
			background = "#1a181a",
			foreground = "#e3e1e4",
			cursor_bg = "#e3e1e4",
			cursor_fg = "#2d2a2e",
			cursor_border = "#848089",
			ansi = {
				"#2d2a2e",
				"#ff6188",
				"#a9dc76",
				"#e5c463",
				"#78dce8",
				"#ab9df2",
				"#78dce8",
				"#e3e1e4",
			},
			brights = {
				"#848089",
				"#f85e84",
				"#98e024",
				"#e5c463",
				"#7accd7",
				"#ab9df2",
				"#78dce8",
				"#e3e1e4",
			},
		},
	},
	-- default_prog = { "/usr/bin/zsh", "-l", "-c", "tmux attach || tmux" },
	disable_default_key_bindings = true,
	-- font = wezterm.font("Fira Code"),
	-- font = wezterm.font("VictorMono Nerd Font", {weight = "DemiBold"}),
	-- font = wezterm.font(mono_font),
	-- front_end = "WebGpu",
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    { key = "a", mods = "LEADER|CTRL",  action=wezterm.action{SendString="\x01"}},
    { key = "-", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    { key = "\\",mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key = "s", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    { key = "v", mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key = "o", mods = "LEADER",       action="TogglePaneZoomState" },
    { key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
    { key = "c", mods = "LEADER",       action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
    { key = "h", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Left"}},
    { key = "j", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Down"}},
    { key = "k", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Up"}},
    { key = "l", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Right"}},
    { key = "H", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 10}}},
    { key = "J", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 10}}},
    { key = "K", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 10}}},
    { key = "L", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 10}}},
    { key = "PageDown", mods = "CTRL",  action=wezterm.action{ActivateTabRelative=1}},
    { key = "PageUp", mods = "CTRL",    action=wezterm.action{ActivateTabRelative=-1}},
    { key = "1", mods = "LEADER",       action=wezterm.action{ActivateTab=0}},
    { key = "2", mods = "LEADER",       action=wezterm.action{ActivateTab=1}},
    { key = "3", mods = "LEADER",       action=wezterm.action{ActivateTab=2}},
    { key = "4", mods = "LEADER",       action=wezterm.action{ActivateTab=3}},
    { key = "5", mods = "LEADER",       action=wezterm.action{ActivateTab=4}},
    { key = "6", mods = "LEADER",       action=wezterm.action{ActivateTab=5}},
    { key = "7", mods = "LEADER",       action=wezterm.action{ActivateTab=6}},
    { key = "8", mods = "LEADER",       action=wezterm.action{ActivateTab=7}},
    { key = "9", mods = "LEADER",       action=wezterm.action{ActivateTab=8}},
    { key = "&", mods = "LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
    { key = "d", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},
    { key = "x", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},
		{
			key = "c",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ CopyTo = "Clipboard" }),
		},
		{
			key = "v",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ PasteFrom = "Clipboard" }),
		},
		{ key = "=", mods = "CTRL", action = "IncreaseFontSize" },
		{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
		{ key = "r", mods = "CTRL|SHIFT", action = "ReloadConfiguration" },
	},
	leader = { key="a", mods="CTRL" },
	-- unix_domains = {
	-- 	{
	-- 		name = 'unix',
	-- 	},
	-- },
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = true,
	warn_about_missing_glyphs = false,
	window_background_opacity = 1.00,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	window_frame = {
		--font = wezterm.font { family = 'Noto Sans', weight = 'Bold' },
		--font_size = 11.0,
		--font = wezterm.font(window_font),
		--active_titlebar_bg = '#962ac3',
		--active_titlebar_bg = '#16171d',
		active_titlebar_bg = 'none',
		--inactive_titlebar_bg = '#1e2128',
		inactive_titlebar_bg = 'none',
	},
  xcursor_theme = xcursor_theme,
  xcursor_size = xcursor_size,

}
