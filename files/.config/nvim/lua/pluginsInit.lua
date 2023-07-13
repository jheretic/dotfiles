local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
    use {
        "wbthomason/packer.nvim",
        event = "VimEnter"
    }

    use {
        "RRethy/vim-illuminate",
        config = function()
            require "plugins.illuminate"
        end
    }

    use "folke/twilight.nvim"

    use {
        "romgrk/nvim-treesitter-context",
        config = function()
            require "plugins.treesitter-context"
        end
    }

    use "neovim/nvim-lspconfig"

    use {
        "williamboman/nvim-lsp-installer",
        after = "nvim-lspconfig",
        config = function()
            require "plugins.lsp"
        end
    }

    use 'JoosepAlviste/nvim-ts-context-commentstring'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require "plugins.treesitter"
        end
    }

    use {
        'numToStr/Comment.nvim',
        config = function()
            require "plugins.comment"
        end
    }

    use {
        "hrsh7th/cmp-nvim-lsp"
    }

    use {
        "hrsh7th/cmp-buffer"
    }

    use {
        "hrsh7th/cmp-path"
    }

    use {
        "hrsh7th/cmp-cmdline"
    }

    use {
        "hrsh7th/nvim-cmp",
        config = function()
            require "plugins.cmp"
        end
    }

    use "L3MON4D3/LuaSnip"

    use "saadparwaiz1/cmp_luasnip"

    use "onsails/lspkind-nvim"

    use 'ggandor/lightspeed.nvim'

    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    use 'nvim-lua/plenary.nvim'

    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function()
            require "plugins.telescope"
        end
    }

    use "kyazdani42/nvim-web-devicons"

    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    }

    use {
        'glepnir/galaxyline.nvim',
        branch = 'main',
        -- some optional icons
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        -- your statusline
        config = function()
            require "plugins.galaxyline"
        end
    }

    use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}

    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
          'kyazdani42/nvim-web-devicons', -- optional, for file icon
        },
        config = function()
            require "plugins.tree"
        end
    }

    use {
        'wxfr/minimap.vim',
        run = 'cargo install --locked code-minimap',
        config = function()
            require "plugins.minimap"
        end
    }

    use 'folke/lsp-colors.nvim'

    use 'sainnhe/sonokai'

    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require('colorizer').setup()
        end
    }

    use 'p00f/nvim-ts-rainbow'

    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require "plugins.indent-blankline"
        end
    }

--    use {
--        "blackCauldron7/surround.nvim",
--        config = function()
--            require "plugins.surround"
--        end
--    }
--
--    use {
--        "windwp/nvim-autopairs",
--        config = function()
--            require "plugins.autopairs"
--        end
--    }

    use {
        "aserowy/tmux.nvim",
        config = function()
            require "plugins.tmux"
        end
    }

    use 'tpope/vim-obsession'

    use {
      'goolord/alpha-nvim',
      config = function ()
          require'alpha'.setup(require'alpha.themes.dashboard'.opts)
      end
    }

    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('gitsigns').setup()
        end
    }

    use 'mfussenegger/nvim-dap'

    use 'mfussenegger/nvim-dap-virtual-text'

    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

    use "Pocco81/DAPInstall.nvim"

    use {
      "rcarriga/nvim-notify",
      config = function()
        require "plugins.notify"
      end

    }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
