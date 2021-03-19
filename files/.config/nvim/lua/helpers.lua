-------------------- HELPERS -------------------------------
-- Inspired by github.com/ojroques

local cmd, fn, g = vim.cmd, vim.fn, vim.g
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

-- Escape termcodes
local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- From https://github.com/norcalli/nvim_utils
local function augroups(definitions)
	for group_name, definition in pairs(definitions) do
		api.nvim_command('augroup '..group_name)
		api.nvim_command('autocmd!')
		for _, def in ipairs(definition) do
			-- if type(def) == 'table' and type(def[#def]) == 'function' then
			-- 	def[#def] = lua_callback(def[#def])
			-- end
			local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
			api.nvim_command(command)
		end
		api.nvim_command('augroup END')
	end
end

-- From https://github.com/richin13/dotfiles
local function is_buffer_empty()
  -- Check whether the current buffer is empty
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

local function has_width_gt(cols)
  -- Check if the windows width is greater than a given number of columns
  return vim.fn.winwidth(0) / 2 > cols
end

return {t=t, opt=opt, map=map, augroups=augroups, is_buffer_empty=is_buffer_empty, has_width_gt=has_width_gt}
