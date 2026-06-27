return {
	"stevearc/conform.nvim",
	config = function()
		local utils = require("core.utils")

		require("conform").setup({
			format_on_save = {
				timeout_ms = 5000,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				go = function()
					if vim.fn.executable("goimports") == 1 then
						return { "goimports" }
					end
					return {}
				end,
				php = { "phpcbf" },
				java = { "google-java-format" },
				terraform = function()
					if vim.fn.executable("terraform") == 1 then
						return { "terraform_fmt" }
					end
					return {}
				end,
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
			},
			formatters = {
				phpcbf = {
					prepend_args = function()
						local standard = utils.is_wordpress_project(vim.api.nvim_buf_get_name(0)) and "WordPress"
							or "PSR12"
						return { "--standard=" .. standard }
					end,
				},
			},
		})

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ bufnr = 0 })
		end, { desc = "Format buffer" })
	end,
}
