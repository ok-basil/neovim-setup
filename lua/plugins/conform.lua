return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require('conform').setup {
      format_on_save = {
        timeout_ms = 5000,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        go = { 'goimports' },
        php = { 'phpcbf' },
        java = { 'google-java-format' },
        terraform = { 'terraform_fmt' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
      },
    }

    vim.keymap.set('n', '<leader>f', function()
      require('conform').format { bufnr = 0 }
    end, { desc = 'Format buffer' })
  end,
}
