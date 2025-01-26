return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    local ai = require 'mini.ai'
    ai.setup {
      n_lines = 500,
      custom_textobjects = {
        -- https://github.com/LazyVim/LazyVim/blob/eb525c680d0423f5addb12e10f87ce5b81fc0d9e/lua/lazyvim/plugins/coding.lua
        o = ai.gen_spec.treesitter { -- code block
          a = { '@block.outer', '@conditional.outer', '@loop.outer' },
          i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        },
        f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' }, -- function
        c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' }, -- class
        j = ai.gen_spec.treesitter { a = '@jsx_tag.outer', i = '@jsx_tag.inner' }, -- jsx tags
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
        d = { '%f[%d]%d+' }, -- digits
        e = { -- Word with case
          { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
          '^().*()$',
        },
        u = ai.gen_spec.function_call(), -- u for "Usage"
        U = ai.gen_spec.function_call { name_pattern = '[%w_]' }, -- without dot in function name
      },
    }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    -- Configuration inspired by: https://github.com/echasnovski/mini.nvim/discussions/80#discussioncomment-2719781
    -- Works similar to tpope/vim-surround
    require('mini.surround').setup {
      custom_surroundings = {
        ['('] = { output = { left = '( ', right = ' )' } },
        ['['] = { output = { left = '[ ', right = ' ]' } },
        ['{'] = { output = { left = '{ ', right = ' }' } },
        ['<'] = { output = { left = '< ', right = ' >' } },
      },
      mappings = {
        add = 'ys',
        delete = 'ds',
        find = '',
        find_left = '',
        highlight = '',
        replace = 'cs',
        update_n_lines = '',
      },
      search_method = 'cover_or_next',
    }

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim

    require('ts_context_commentstring').setup {
      enable_autocmd = false,
    }

    require('mini.comment').setup {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    }

    require('mini.animate').setup {
      cursor = { enable = false },
      resize = { enable = false },
      open = { enable = false },
      close = { enable = false },
    }

    require('mini.splitjoin').setup {
      mappings = {
        toggle = 'gs',
      },
    }

    require('mini.operators').setup()
    require('mini.pairs').setup()
    require('mini.bufremove').setup()

    require('mini.files').setup()
    vim.keymap.set('n', '<leader>-', MiniFiles.open, { desc = 'Open mini.files' })

    require('mini.animate').setup()

    if vim.g.have_nerd_font then
      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()
    end

    require('mini.tabline').setup()

    local starter = require 'mini.starter'
    starter.setup {
      items = {
        starter.sections.builtin_actions(),
        {
          name = 'Open Oil.nvim',
          action = 'Oil',
          section = 'Builtin actions', -- techincally not, but i'd like them grouped.
        },
        starter.sections.telescope(),
        starter.sections.recent_files(10, true),
      },
    }
  end,
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
}
