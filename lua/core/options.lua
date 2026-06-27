vim.wo.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.linebreak = true
vim.o.mouse = "a"
vim.o.autoindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2"

vim.diagnostic.config({
	float = {
		border = "rounded",
		source = true,
	},
	severity_sort = true,
	signs = true,
	underline = {
		severity = {
			min = vim.diagnostic.severity.WARN,
		},
	},
	update_in_insert = false,
	virtual_text = false,
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#fabd2f" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = false, sp = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = false, sp = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineOk", { underline = false, sp = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#fb4934" })
