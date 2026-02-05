return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' },
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    local home = vim.env.HOME
    local jdtls = require 'jdtls'
    local root_markers = { 'pom.xml', 'build.gradle', '.git' }
    local root_dir = require('jdtls.setup').find_root(root_markers)
    if not root_dir then
      return
    end

    local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
    local workspace_dir = home .. '/.local/share/eclipse/' .. project_name

    local bundles = {
      vim.fn.glob(home .. '/.local/share/nvim/mason/packages/java-test/extension/server/*.jar'),
      vim.fn.glob(home .. '/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'),
    }

  local config = {
      cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/jdtls',
        '-configuration', home .. '/.local/share/jdtls/config',
        '-data', workspace_dir,
      },
      root_dir = root_dir,
      settings = {},
      init_options = {
        bundles = bundles,
      },
    }

    jdtls.start_or_attach(config)
  end,
}
