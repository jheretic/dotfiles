local lsp_installer = require "nvim-lsp-installer"
local null_ls = require "null-ls"

local helpers = require('../helpers')

local map, bmap = helpers.map, helpers.bmap
local cmd, fn = vim.cmd, vim.fn

-- Include the servers you want to have installed by default below
local servers = {
  "bashls",
  "clangd",
  "dockerls",
  "gopls",
  "html",
  "jsonls",
  "lemminx",
  "pyright",
  "rust_analyzer",
  "solargraph",
  "sqls",
  "sumneko_lua",
  "taplo",
  "tsserver",
  "yamlls",
  "zk",
}

-- Default buffer attach handler
local function on_attach(client, buf)
    -- set up buffer-local keymaps, options, etc

    -- Enable completion triggered by <c-x><c-o>
    --cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")

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
    bmap(buf, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
    bmap(buf, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    bmap(buf, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    bmap(buf, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
    bmap(buf, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

    -- illuminate the word under cursor
    require'illuminate'.on_attach(client)

    -- Format on save by default
    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
end

-- Default options for all language servers
local default_opts = {
    on_attach = on_attach,
}

-- Per-LS overrides
local opts_for = {
      -- Provide settings that should only apply to the "eslintls" server
  ["eslintls"] = function(opts)
    opts.settings = {
      format = {
        enable = true,
      },
    }
  end,
}

-- Setup LSP servers, install them if not present
for _, name in pairs(servers) do
    local is_found, server = lsp_installer.get_server(name)
    if is_found then
        local opts = {}
        -- set default options
        setmetatable(opts, {__index = function (k) return default_opts[k] end})
        server:on_ready(function ()
            if opts_for[name] then
                opts_for[name](opts)
            end
            server:setup(opts)
        end)
        if not server:is_installed() then
            -- Queue the server to be installed
            server:install()
        end
    end
end

null_ls.setup({
    on_attach = on_attach,
    sources = {
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.code_actions.gitsigns,
    },
  })
