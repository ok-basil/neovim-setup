return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local utils = require("core.utils")

		local eslint_filetypes = {
			javascript = true,
			javascriptreact = true,
			typescript = true,
			typescriptreact = true,
		}

		local eslint_markers = {
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.json",
			"eslint.config.js",
			"eslint.config.mjs",
		}

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			php = { "phpcs" },
			make = { "checkmake" },
		}

		local phpcs = lint.linters.phpcs
		local default_phpcs_args = vim.deepcopy(phpcs.args)

		phpcs.args = function()
			local args = vim.deepcopy(default_phpcs_args)
			local standard = utils.is_wordpress_project(vim.api.nvim_buf_get_name(0)) and "WordPress" or "PSR12"
			table.insert(args, 2, "--standard=" .. standard)
			return args
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = function()
				local bufname = vim.api.nvim_buf_get_name(0)
				if eslint_filetypes[vim.bo.filetype] and not utils.project_root(bufname, eslint_markers) then
					return
				end

				lint.try_lint()
			end,
		})
	end,
}
