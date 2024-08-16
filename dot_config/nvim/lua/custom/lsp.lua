-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', function()
    vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
  end, '[C]ode [A]ction')

  nmap('<leader>gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<leader>gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require 'lspconfig'
local util = lspconfig.util

local root_path = util.find_git_ancestor(vim.fn.getcwd())

local is_yarn_pnp = util.path.is_file(util.path.join(root_path, '.pnp.cjs'))
local is_biome = util.path.is_file(util.path.join(root_path, 'biome.json'))

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  rust_analyzer = {},
  -- tsserver = {}, -- replaced with typescript-tools
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  eslint = {
    nodePath = is_yarn_pnp and util.path.join(root_path, '.yarn/sdks') or nil,
  },
  bashls = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },

  yamlls = {
    schemaStore = {
      enable = true,
    },
    schemas = {
      kubernetes = '*.yaml',
      ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
      ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
      ['http://json.schemastore.org/ansible-stable-2.9'] = 'roles/tasks/*.{yml,yaml}',
      ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
      ['http://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
      ['http://json.schemastore.org/ansible-playbook'] = '*play*.{yml,yaml}',
      ['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
      ['https://json.schemastore.org/dependabot-v2'] = '.github/dependabot.{yml,yaml}',
      ['https://json.schemastore.org/gitlab-ci'] = '*gitlab-ci*.{yml,yaml}',
      ['https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json'] = '*api*.{yml,yaml}',
      ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = '*docker-compose*.{yml,yaml}',
      ['https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json'] = '*flow*.{yml,yaml}',
      ['https://taskfile.dev/schema.json'] = 'Taskfile.yml',
      ['https://yarnpkg.com/configuration/yarnrc.json'] = '.yarnrc.yml',
      ['https://json.schemastore.org/circleciconfig.json'] = '.circleci/config.yml',
    }, -- https://www.reddit.com/r/neovim/comments/ze9gbe/comment/iz59clw/
  },

  terraformls = {},
  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

local null_ls = require 'null-ls'
local command_resolver = require 'null-ls.helpers.command_resolver'

-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md#ruff-1
null_ls.setup {
  debug = true,
  sources = {
    null_ls.builtins.formatting.prettier.with {
      dynamic_command = command_resolver.from_yarn_pnp(),
      condition = function()
        return not is_biome and is_yarn_pnp
      end,
    },

    null_ls.builtins.formatting.prettier.with {
      condition = function()
        return not is_biome and not is_yarn_pnp
      end,
    },

    null_ls.builtins.formatting.biome.with {
      condition = function()
        return is_biome
      end,
    },
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.code_actions.gitsigns,
  },
}

require('typescript-tools').setup {
  on_attach = on_attach,
}
