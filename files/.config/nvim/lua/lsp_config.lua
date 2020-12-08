local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')

-- completion-nvim & diagnostic-nvim

local map = function(type, key, value)
  vim.fn.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
end

function do_format()
  --vim.lsp.buf.formatting_sync(nil, 1000)
  vim.lsp.buf.formatting()
end

local attach_formatting = function(client)
  -- Skip tsserver for now so we dont format things twice
  -- if client.name == "tsserver" then return end
  print(string.format('attaching format to %s', client.name))

  vim.api.nvim_command [[augroup Format]]
  vim.api.nvim_command [[autocmd! * <buffer>]]
  vim.api.nvim_command [[autocmd BufWritePost <buffer> lua do_format()]]
  vim.api.nvim_command [[augroup END]]
end

local on_attach_vim = function(client)
  lsp_status.register_progress()
  lsp_status.register_client(client.name);
  lsp_status.config({
    current_function = true,
    indicator_errors = '',
    indicator_warnings = '',
    indicator_info = '',
    indicator_hint = '',
    indicator_ok = '',
  })
  print("'" .. client.name .. "' language server attached");
  require'completion'.on_attach(client)
  require"lsp-status".on_attach(client)

  vim.cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")

  --capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)
  if client.resolved_capabilities.document_formatting then
    print(string.format("Formatting supported %s", client.name))

    attach_formatting(client)
  end

  map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
  map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n','<leader>af','<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n','<leader>ee','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>')
  map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
  map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
  map('n','<leader>gd','<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  map('n','<leader>gD','<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
end

local default_lsp_config = {on_attach = on_attach_vim, capabilities = lsp_status.capabilities}

local servers = {"bashls", "cmake", "cssls", "dockerls", "gopls", "html", "jsonls", "kotlin_language_server", "pyls", "rust_analyzer", "solargraph", "sqlls", "sumneko_lua", "tsserver", "vimls", "yamlls"}

--lspconfig.efm.setup{
--	filetypes = {"javascript", "typescript"},
--	--cmd = {"efm-langserver", "-logfile", "/tmp/efm.log", "-loglevel", "2"},
--	on_attach=on_attach_vim,
--	--root_dir = lspconfig.util.root_pattern("RCS/", "SCCS/", "CVS/", ".git/", ".svn/", ".hg/", ".bzr/", "_darcs/", ".git"),
--	-- Enable document formatting (other capabilities are off by default).
--	init_options = {
--		documentFormatting = true,
--		hover = true,
--		documentSymbol = true,
--		codeAction = true,
--		completion = true,
--	},
--	settings = {
--		rootMarkers = {"RCS/", "SCCS/", "CVS/", ".git/", ".svn/", ".hg/", ".bzr/", "_darcs/", ".git"},
--		languages = {
--			javascript = {
--				{
--	       				lintCommand = "npx eslint -f unix --stdin --stdin-filename ${INPUT}",
--					lintIgnoreExitCode = true,
--					lintStdin = true,
--					formatCommand = "npx eslint --fix ${INPUT}",
--					formatStdin = true,
--					rootMarkers = {
--						"package.json", ".eslintrc.js", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json"
--					}
--				}
--			},
--			typescript = {
--				{
--	       				lintCommand = "npx eslint -f unix --stdin --stdin-filename ${INPUT}",
--					lintIgnoreExitCode = true,
--					lintStdin = true,
--					formatCommand = "npx eslint --fix ${INPUT}",
--					formatStdin = true,
--					rootMarkers = {
--						"package.json", ".eslintrc.js", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json"
--					}
--				}
--			},
--		},
--	}
--}

lspconfig.diagnosticls.setup {
  on_attach = on_attach_vim,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "css",
    "scss",
    "markdown",
    -- "pandoc",
  },
  init_options = {
    linters = {
      eslint = {
        command = "eslint",
        rootPatterns = {".git", ".eslintrc", ".eslintrc.json", ".eslintrc.js"},
        debounce = 100,
        args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
        sourceName = "eslint",
        parseJson = {
          errorsRoot = "[0].messages",
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "[eslint] ${message} [${ruleId}]",
          security = "severity",
        },
        securities = {[2] = "error", [1] = "warning"},
      },
      markdownlint = {
        command = "markdownlint",
        rootPatterns = {".git"},
        isStderr = true,
        debounce = 100,
        args = {"--stdin"},
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "markdownlint",
        securities = {undefined = "hint"},
        formatLines = 1,
        formatPattern = {"^.*:(\\d+)\\s+(.*)$", {line = 1, column = -1, message = 2}},
      },
    },
    filetypes = {
      javascript = "eslint",
      javascriptreact = "eslint",
      typescript = "eslint",
      typescriptreact = "eslint",
      ["typescript.tsx"] = "eslint",
      markdown = "markdownlint",
      -- pandoc = "markdownlint",
    },
    formatters = {
      eslint = {
        command = "eslint",
        args = {"--fix", "%file"},
        doesWriteToFile = true,
        rootPatterns = {"package.json", ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".git"},
      },
      prettier = {command = "prettier", args = {"--stdin-filepath", "%filename"}},
    },
    formatFiletypes = {
      css = "prettier",
      javascript = "eslint",
      javascriptreact = "eslint",
      json = "prettier",
      scss = "prettier",
      typescript = "eslint",
      typescriptreact = "eslint",
      --["typescript.tsx"] = "eslint",
    },
  },
}

for _, server in ipairs(servers) do lspconfig[server].setup(default_lsp_config) end

-- nvim-lsputils
vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end
vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
