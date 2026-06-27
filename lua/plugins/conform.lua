return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    local is_wordpress = function(ctx)
      return vim.fs.find({ 'wp-config.php', 'wp-config-sample.php' }, {
        upward = true,
        path = ctx.dirname,
      })[1] ~= nil
    end

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
      formatters = {
        phpcbf = {
          args = function(_, ctx)
            local standard = is_wordpress(ctx) and 'WordPress' or 'PSR12'
            return { '--standard=' .. standard, '$FILENAME' }
          end,
        },
      },
    }

    vim.keymap.set('n', '<leader>f', function()
      require('conform').format { bufnr = 0 }
    end, { desc = 'Format buffer' })
  end,
}
