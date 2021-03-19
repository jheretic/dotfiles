local lspconfig = require('lspconfig')
local saga = require('lspsaga')
--local lsp_status = require('lsp-status')

saga.init_lsp_saga()
-------------------- HELPERS -------------------------------
local cmd, fn = vim.cmd, vim.fn

local helpers = require('helpers')
local map = helpers.map

-------------------- CALLBACKS -----------------------------

local on_attach_vim = function(client)
  cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

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

  cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")

--  map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
--  map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
--  --map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
--  map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
--  map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
--  map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
--  map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
--  map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
--  map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
--  map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
--  map('n','<leader>af','<cmd>lua vim.lsp.buf.code_action()<CR>')
--  map('n','<leader>ee','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>')
--  map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
--  map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
--  map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
--  map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
--  map('n','<leader>gd','<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
--  map('n','<leader>gD','<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')

  map('n', 'gh', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>')
  map('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>')
  map('v', '<leader>ca', "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>")
  map('n', 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")
  map('n', '<C-f>', "<cmd>lua require('lspsaga.hover').smart_scroll_hover(1)<CR>")
  map('n', '<C-b>', "<cmd>lua require('lspsaga.hover').smart_scroll_hover(-1)<CR>")
  map('n', 'gs', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>")
  map('n', 'gr', "<cmd>lua require('lspsaga.rename').rename()<CR>")
  map('n', 'gd', "<cmd>lua require('lspsaga.provider').preview_definition()<CR>")
  map('n', '<leader>cd', "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>")
  map('n', '[e', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>")
  map('n', ']e', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>")
  map('n', '<A-d>', "<cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>")
  map('t', '<A-d>', [[<C-\><C-n><cmd>lua require('lspsaga.floaterm').close_float_terminal()<CR>]])

  require 'illuminate'.on_attach(client)
end

-------------------- LSP -----------------------------------
--local default_lsp_config = {on_attach = on_attach_vim, capabilities = lsp_status.capabilities}
local default_lsp_config = {on_attach = on_attach_vim}

local servers = {"bashls", "cmake", "cssls", "dockerls", "gopls", "html", "jsonls", "kotlin_language_server", "pyls", "rust_analyzer", "solargraph", "sqlls", "vimls", "yamlls"}

lspconfig.tsserver.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    on_attach_vim(client)
  end
}

lspconfig.sumneko_lua.setup {
  on_attach = on_attach_vim,
--  capabilities = lsp_status.capabilities,
  settings = {
    Lua = {
      diagnostics = {
          globals = { 'vim' }
      }
    }
  }
}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
}

lspconfig.efm.setup {
  init_options = {documentFormatting = false},
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    --client.resolved_capabilities.goto_definition = false
    on_attach_vim(client)
  end,
  settings = {
    rootMarkers = {".git/"},
    languages = {
      javascript = {eslint},
      javascriptreact = {eslint},
      ["javascript.jsx"] = {eslint},
      typescript = {eslint},
      ["typescript.tsx"] = {eslint},
      typescriptreact = {eslint}
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact"
  },
}

for _, server in ipairs(servers) do lspconfig[server].setup(default_lsp_config) end

-------------------- HANDLERS ------------------------------
fn.sign_define('LspDiagnosticsSignError', { text = "", texthl = "LspDiagnosticsSignError" })
fn.sign_define('LspDiagnosticsSignWarning', { text = "", texthl = "LspDiagnosticsSignWarning" })
fn.sign_define('LspDiagnosticsSignInformation', { text = "", texthl = "LspDiagnosticsSignInformation" })
fn.sign_define('LspDiagnosticsSignHint', { text = "", texthl = "LspDiagnosticsSignHint" })
