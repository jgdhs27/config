local wezterm = require 'wezterm'

local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action

--- Get the current operating system
--- @return "windows"| "linux" | "macos"
local function get_os()
  local triple = wezterm.target_triple
  if triple:find("windows") then
    return "windows"
  elseif triple:find("darwin") then
    return "macos"
  else
    return "linux"
  end
end

local host_os = get_os()

-- Set cursor styles
config.default_cursor_style = "SteadyBar"

-- Full screen on startup
wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window {}
  window:gui_window():maximize()
end)

-- Shell
if host_os == "windows" then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
else
  config.default_prog = { "/usr/bin/fish", "-l" }
end

-- Font
config.font = wezterm.font_with_fallback({
  "MesloLGM Nerd Font Regular",
  "Noto Color Emoji", -- emoji fallback
})
config.font_size = 14.0

-- Colors
-- config.color_scheme = 'Colors (base16)'
-- config.color_scheme = 'Materia (base16)'
-- config.color_scheme = 'Material (base16)'
config.color_scheme = 'MaterialDesignColors'

-- Window appearance
config.window_padding = {
  left = 4, right = 4, top = 0, bottom = 0,
}

-- Tab Bar Configuration
config.use_fancy_tab_bar = true
config.show_tab_index_in_tab_bar = false

-- Keybindings
local function mod_ctrl()
  return os == "macos" and "SUPER" or "CTRL"
end

config.leader = { key = 'F20', timeout_milliseconds = 2000 }
config.keys = {
  -- Tabs
  { key = "t", mods = mod_ctrl(), action = act.SpawnTab "CurrentPaneDomain" },
  { key = 'w', mods = mod_ctrl(), action = act.CloseCurrentPane { confirm = true }, },
  -- Panes
  { key = "v", mods = "LEADER",   action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "s", mods = "LEADER",   action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "h", mods = "LEADER",   action = act.ActivatePaneDirection "Left", },
  { key = "j", mods = "LEADER",   action = act.ActivatePaneDirection "Down", },
  { key = "k", mods = "LEADER",   action = act.ActivatePaneDirection "Up", },
  { key = "l", mods = "LEADER",   action = act.ActivatePaneDirection "Right", },
  { key = "L", mods = "LEADER",   action = act.RotatePanes "Clockwise" },
  { key = "H", mods = "LEADER",   action = act.RotatePanes "CounterClockwise", },
  { key = "q", mods = "LEADER",   action = act.CloseCurrentPane { confirm = false } },
  { key = "r", mods = "LEADER",   action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false, }, },
  -- Copy/Paste
  { key = "c", mods = mod_ctrl(), action = act.DisableDefaultAssignment },
  { key = "v", mods = mod_ctrl(), action = act.PasteFrom "Clipboard" },
  { key = "f", mods = mod_ctrl(), action = act.Search({ CaseInSensitiveString = '' }) },
  -- Navigation
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = act.DisableDefaultAssignment,
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = act.DisableDefaultAssignment,
  }
}

-- Scrollback
config.scrollback_lines = 10000

return config
