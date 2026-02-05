return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvimtools/none-ls-extras.nvim',
        'jayp0521/mason-null-ls.nvim', -- ensure dependencies are instaled
    },
    config = function()
        local null_ls = require 'null-ls'
        local diagnostics = null_ls.builtins.diagnostics -- to setup linters

        -- Formatters & linters for mason to install
        require('mason-null-ls').setup {
            ensure_installed = {
                'prettier', -- ts/js formatter
                'eslint_d', --ts/js linter
                'ruff', -- python linter and formatter
                'stylua', -- lua formatter
                'shfmt', -- shell formatter
                'phpcs', -- php linter
                'phpcbf', -- php formatter
                'pint',  -- Laravel pint
                'google_java_format', -- java formatter
            },
            automatic_installation = true,
        }

        local sources = {
            diagnostics.checkmake,
            diagnostics.phpcs.with {
                extra_args = {
                    '--standard=PSR12',
                },
            },
        }

        null_ls.setup {
            -- debug = true -- Enable debug mode. Inspect logs with :NullLsLog.
            sources = sources,
        }
    end,
}
