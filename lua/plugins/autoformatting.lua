return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvimtools/none-ls-extras.nvim',
        'jayp0521/mason-null-ls.nvim',
    },
    config = function()
        local null_ls = require 'null-ls'
        local diagnostics = null_ls.builtins.diagnostics

        -- Tools installed via Mason (used by conform.nvim and none-ls)
        require('mason-null-ls').setup {
            ensure_installed = {
                'prettier',
                'eslint_d',
                'ruff',
                'stylua',
                'shfmt',
                'phpcs',
                'phpcbf',
                'google_java_format',
            },
            automatic_installation = true,
        }

        local is_wordpress = function(utils)
            return utils.root_has_file { 'wp-config.php', 'wp-config-sample.php' }
        end

        null_ls.setup {
            sources = {
                diagnostics.checkmake,

                -- PHP: PSR12 for standard projects, WordPress standard for WP projects
                diagnostics.phpcs.with {
                    extra_args = { '--standard=PSR12' },
                    condition = function(utils) return not is_wordpress(utils) end,
                },
                diagnostics.phpcs.with {
                    extra_args = { '--standard=WordPress' },
                    condition = is_wordpress,
                },

                -- JS/TS: only in projects with an eslint config
                require('none-ls.diagnostics.eslint_d').with {
                    condition = function(utils)
                        return utils.root_has_file { '.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.json', 'eslint.config.js', 'eslint.config.mjs' }
                    end,
                },
            },
        }
    end,
}
