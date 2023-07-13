local nvim_lsp = require('lspconfig')
local saga = require('lspsaga')
-- local lsp_status = require('lsp-status')

saga.init_lsp_saga()
-------------------- HELPERS -------------------------------
local cmd, fn = vim.cmd, vim.fn

local helpers = require('helpers')
local map, bmap = helpers.map, helpers.bmap

-------------------- CALLBACKS -----------------------------

local on_attach_nvim = function(client, buf)
    -- cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

    -- commented options are defaults
    require('lspkind').init({
        -- with_text = true,
        -- symbol_map = {
        --   Text = '',
        --   Method = 'ƒ',
        --   Function = '',
        --   Constructor = '',
        --   Variable = '',
        --   Class = '',
        --   Interface = 'ﰮ',
        --   Module = '',
        --   Property = '',
        --   Unit = '',
        --   Value = '',
        --   Enum = '了',
        --   Keyword = '',
        --   Snippet = '﬌',
        --   Color = '',
        --   File = '',
        --   Folder = '',
        --   EnumMember = '',
        --   Constant = '',
        --   Struct = ''
        -- },
    })

    -- Enable completion triggered by <c-x><c-o>
    cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")

    bmap(buf, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    bmap(buf, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    bmap(buf, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    bmap(buf, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    bmap(buf, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    bmap(buf, 'n', '<space>wa',
         '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
    bmap(buf, 'n', '<space>wr',
         '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
    bmap(buf, 'n', '<space>wl',
         '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
    bmap(buf, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    bmap(buf, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    bmap(buf, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    bmap(buf, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    bmap(buf, 'n', '<space>e',
         '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    bmap(buf, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    bmap(buf, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    bmap(buf, 'n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
    bmap(buf, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

    -- map('n', 'gh', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>')
    -- map('n', '<leader>ca',
    --    '<cmd>lua require("lspsaga.codeaction").code_action()<CR>')
    -- map('v', '<leader>ca',
    --    "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>")
    -- map('n', 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")
    -- map('n', '<C-f>',
    --    "<cmd>lua require('lspsaga.hover').smart_scroll_hover(1)<CR>")
    -- map('n', '<C-b>',
    --    "<cmd>lua require('lspsaga.hover').smart_scroll_hover(-1)<CR>")
    -- map('n', 'gs',
    --    "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>")
    -- map('n', 'gr', "<cmd>lua require('lspsaga.rename').rename()<CR>")
    -- map('n', 'gd',
    --    "<cmd>lua require('lspsaga.provider').preview_definition()<CR>")
    -- map('n', '<leader>cd',
    --    "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>")
    -- map('n', '[e',
    --    "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>")
    -- map('n', ']e',
    --    "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>")
    -- map('n', '<A-d>',
    --    "<cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>")
    -- map('t', '<A-d>',
    --    [[<C-\><C-n><cmd>lua require('lspsaga.floaterm').close_float_terminal()<CR>]])

    require'illuminate'.on_attach(client)
end

-------------------- LSP -----------------------------------
-- local default_lsp_config = {on_attach = on_attach_nvim, capabilities = lsp_status.capabilities}
local default_lsp_config = {
    on_attach = on_attach_nvim,
    flags = {debounce_text_changes = 150}
}

-- sumneko configuration
local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
else
    print("Unsupported system for sumneko")
end
-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = vim.fn.stdpath('cache') ..
                              '/nvim_lsp/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name ..
                           "/lua-language-server"
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach_nvim(client)
    end
}

nvim_lsp.sumneko_lua.setup {
    on_attach = on_attach_nvim,
    --  capabilities = lsp_status.capabilities,
    --  settings = {Lua = {diagnostics = {globals = {'vim'}}}}
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {enable = false}
        }
    }
}

local eslint = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    lintIgnoreExitCode = true
}

local rufo = {
    lintCommand = "rufo --check --filename ${INPUT}",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    lintIgnoreExitCode = true
}

nvim_lsp.efm.setup {
    init_options = {documentFormatting = false},
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        -- client.resolved_capabilities.goto_definition = false
        on_attach_nvim(client)
    end,
    settings = {
        rootMarkers = {".git/"},
        languages = {
            javascript = {eslint},
            javascriptreact = {eslint},
            ["javascript.jsx"] = {eslint},
            typescript = {eslint},
            ["typescript.tsx"] = {eslint},
            typescriptreact = {eslint},
            ruby = {rufo}
        }
    },
    filetypes = {
        "javascript", "javascriptreact", "javascript.jsx", "typescript",
        "typescript.tsx", "typescriptreact", "ruby"
    }
}

-- for _, server in ipairs(servers) do nvim_lsp[server].setup(default_lsp_config) end
local servers = {
    'bashls', 'cmake', 'cssls', 'dockerls', 'gopls', 'html', 'jsonls',
    'kotlin_language_server', 'pyright', 'solargraph', 'sqlls', 'vimls',
    'yamlls'
}
for _, lsp in ipairs(servers) do nvim_lsp[lsp].setup(default_lsp_config) end

-- rust-tools
local opts = {
    tools = { -- rust-tools options
        -- automatically set inlay hints (type hints)
        -- There is an issue due to which the hints are not applied on the first
        -- opened file. For now, write to the file to trigger a reapplication of
        -- the hints or just run :RustSetInlayHints.
        -- default: true
        autoSetHints = true,

        -- whether to show hover actions inside the hover window
        -- this overrides the default hover handler so something like lspsaga.nvim's hover would be overriden by this
        -- default: true
        hover_with_actions = true,

        -- These apply to the default RustRunnables command
        runnables = {
            -- whether to use telescope for selection menu or not
            -- default: true
            use_telescope = true

            -- rest of the opts are forwarded to telescope
        },

        -- These apply to the default RustSetInlayHints command
        inlay_hints = {
            -- wheter to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<- ",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix = "=> ",

            -- whether to align to the lenght of the longest line in the file
            max_len_align = false,

            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            right_align = false,

            -- padding from the right if right_align is true
            right_align_padding = 7
        },

        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
                {"╭", "FloatBorder"}, {"─", "FloatBorder"},
                {"╮", "FloatBorder"}, {"│", "FloatBorder"},
                {"╯", "FloatBorder"}, {"─", "FloatBorder"},
                {"╰", "FloatBorder"}, {"│", "FloatBorder"}
            },

            -- whether the hover action window gets automatically focused
            -- default: false
            auto_focus = false
        }
    },

    -- all the opts to send to nvim-nvim_lsp
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-nvim_lsp/blob/master/CONFIG.md#rust_analyzer
    server = {} -- rust-analyer options
}

require('rust-tools').setup(opts)

-------------------- HANDLERS ------------------------------
fn.sign_define('LspDiagnosticsSignError',
               {text = "", texthl = "LspDiagnosticsSignError"})
fn.sign_define('LspDiagnosticsSignWarning',
               {text = "", texthl = "LspDiagnosticsSignWarning"})
fn.sign_define('LspDiagnosticsSignInformation',
               {text = "", texthl = "LspDiagnosticsSignInformation"})
fn.sign_define('LspDiagnosticsSignHint',
               {text = "", texthl = "LspDiagnosticsSignHint"})
