local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local fileinfo = require('galaxyline.provider_fileinfo')
local utils = require('helpers')

local section = gl.section
gl.short_line_list = {'defx', 'packager', 'vista'}

-- Colors
-- sonokai_maia
-- local colors = {
--  bg = '#273136',
--  fg = '#e1e2e3',
--  section_bg = '#414b53',
--  yellow = '#e3d367',
--  cyan = '#78cee9',
--  green = '#9cd57b',
--  orange = '#f3a96a',
--  magenta = '#baa0f8',
--  blue = '#78cee9',
--  red = '#f76c7c',
-- }
-- sonokai_shusai
local colors = {
    bg = '#1a181a',
    fg = '#e3e1e4',
    section_bg = '#2d2a2e',
    yellow = '#e5c463',
    cyan = '#78dce8',
    green = '#a9dc76',
    orange = '#ef9062',
    magenta = '#ab9df2',
    blue = '#78dce8',
    red = '#f85e84'
}
-- monokai_soda
-- local colors = {
--  bg = '#1a1a1a',
--  fg = '#c4c5b5',
--  section_bg = '#625e4c',
--  yellow = '#fa8419',
--  cyan = '#58d1eb',
--  green = '#98e024',
--  orange = '#f4005f',
--  magenta = '#baa0f8',
--  blue = '#9d65ff',
--  red = '#f4005f',
-- }

-- Local helper functions
local buffer_not_empty = function() return not utils.is_buffer_empty() end

local checkwidth = function()
    return utils.has_width_gt(40) and buffer_not_empty()
end

local is_git = function()
    return condition.check_git_workspace() and buffer_not_empty()
end

local is_git_checkwidth = function()
    return condition.check_git_workspace() and checkwidth()
end

local printer = function(str) return function() return str end end

local space = printer(' ')

local filetype_icon = function()
    local ff = vim.bo.filetype:upper()
    if ff == 'MAC' then
        return ''
    elseif ff == 'DOS' then
        return ''
    else
        return ''
    end
end

local is_lsp = function()
    print(#vim.lsp.buf_get_clients())
    return #vim.lsp.buf_get_clients() > 0 and buffer_not_empty()
end

local lsp_status = function()
    if #vim.lsp.buf_get_clients() > 0 then
        local current_function = vim.b.lsp_current_function
        if current_function and current_function ~= '' then
            return '' .. '(' .. current_function .. ') '
        end
    end

    return ''
end

local mode_color = function()
    local mode_colors = {
        n = colors.cyan,
        i = colors.green,
        c = colors.orange,
        V = colors.magenta,
        [''] = colors.magenta,
        v = colors.magenta,
        R = colors.red
    }

    return mode_colors[vim.fn.mode()]
end

-- Left side
section.left = {
    {
        Space = {
            provider = space,
            highlight = {colors.section_bg, colors.section_bg}
        }
    }, {
        ViMode = {
            provider = {
                space, function()
                    local alias = {
                        n = 'NORMAL',
                        i = 'INSERT',
                        c = 'COMMAND',
                        V = 'VISUAL',
                        [''] = 'VISUAL',
                        v = 'VISUAL',
                        R = 'REPLACE'
                    }
                    vim.api.nvim_command(
                        'hi GalaxyViMode guifg=' .. mode_color())
                    return alias[vim.fn.mode()]
                end
            },
            highlight = {colors.section_bg, colors.section_bg},
            separator = " ",
            separator_highlight = {colors.section_bg, colors.bg}
        }
    }, {
        GitIcon = {
            provider = function() return ' ' end,
            condition = is_git,
            highlight = {colors.magenta, colors.bg}
        }
    }, {
        GitBranch = {
            provider = 'GitBranch',
            condition = is_git,
            highlight = {colors.fg, colors.bg}
        }
    }, {
        DiffAdd = {
            provider = 'DiffAdd',
            condition = is_git_checkwidth,
            icon = ' ',
            highlight = {colors.green, colors.bg}
        }
    }, {
        DiffModified = {
            provider = 'DiffModified',
            condition = is_git_checkwidth,
            icon = ' ',
            highlight = {colors.orange, colors.bg}
        }
    }, {
        DiffRemove = {
            provider = 'DiffRemove',
            condition = is_git_checkwidth,
            icon = ' ',
            highlight = {colors.red, colors.bg}
        }
    }, {
        DiffSep = {
            provider = space,
            condition = is_git_checkwidth,
            highlight = {colors.bg, colors.bg},
            separator = " ",
            separator_highlight = {colors.bg, colors.section_bg}
        }
    }, {
        DiagnosticError = {
            provider = 'DiagnosticError',
            condition = is_git_checkwidth,
            icon = '  ',
            highlight = {colors.red, colors.section_bg}
        }
    }, {
        DiagnosticWarn = {
            provider = 'DiagnosticWarn',
            condition = is_git_checkwidth,
            icon = '  ',
            highlight = {colors.orange, colors.section_bg}
        }
    }, {
        DiagnosticInfo = {
            provider = 'DiagnosticInfo',
            condition = is_git_checkwidth,
            icon = '  ',
            highlight = {colors.blue, colors.section_bg}
        }
    }, {
        DiagnosticSep = {
            provider = space,
            condition = is_git_checkwidth,
            highlight = {colors.section_bg, colors.section_bg},
            separator = " ",
            separator_highlight = {colors.section_bg, colors.bg}
        }
    }, {
        FileName = {
            provider = 'FileName',
            condition = buffer_not_empty,
            highlight = {colors.fg, colors.bg}
        }
    }
}

-- Right side
section.right = {
    {
        Lsp = {
            provider = {lsp_status},
            condition = buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color, colors.bg}
        }
    }, {
        FileTypeIcon = {
            provider = {filetype_icon, space},
            condition = buffer_not_empty,
            highlight = {colors.yellow, colors.section_bg},
            separator = ' ',
            separator_highlight = {colors.bg, colors.section_bg}
        }
    }, {
        FileEncode = {
            provider = {'FileEncode', space},
            condition = buffer_not_empty,
            highlight = {colors.fg, colors.section_bg}
        }
    }, {
        LineLabel = {
            provider = function() return ' ' end,
            condition = buffer_not_empty,
            highlight = {colors.green, colors.bg},
            separator = ' ',
            separator_highlight = {colors.section_bg, colors.bg}
        }
    }, {
        LineInfo = {
            provider = {'LineColumn', space},
            condition = buffer_not_empty,
            highlight = {colors.fg, colors.bg}
        }
    }, {
        PercentLabel = {
            provider = function() return '☰ ' end,
            condition = buffer_not_empty,
            highlight = {colors.green, colors.bg}
        }
    }, {
        LinePercent = {
            provider = 'LinePercent',
            condition = buffer_not_empty,
            highlight = {colors.fg, colors.bg}
        }
    }, {
        FileIcon = {
            provider = 'FileIcon',
            condition = buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color, colors.section_bg},
            separator = ' ',
            separator_highlight = {colors.bg, colors.section_bg}
        }
    }
}

-- Short status line
section.short_line_left = {
    {
        Space = {
            provider = space,
            highlight = {colors.section_bg, colors.section_bg}
        }
    }, {
        BufferType = {
            provider = 'FileIcon',
            highlight = {fileinfo.get_file_icon_color, colors.section_bg},
            separator = ' ',
            separator_highlight = {colors.section_bg, colors.bg}
        }
    }
}

section.short_line_right = {
    {
        Heart = {
            provider = 'BufferIcon',
            highlight = {fileinfo.get_file_icon_color, colors.section_bg},
            separator = ' ',
            separator_highlight = {colors.bg, colors.section_bg}
        }
    }
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
