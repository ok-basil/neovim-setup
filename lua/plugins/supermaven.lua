return {
	"supermaven-inc/supermaven-nvim",
	cmd = {
		"SupermavenStart",
		"SupermavenStop",
		"SupermavenRestart",
		"SupermavenToggle",
		"SupermavenStatus",
		"SupermavenUseFree",
		"SupermavenUsePro",
		"SupermavenLogout",
		"SupermavenShowLog",
		"SupermavenClearLog",
	},
	event = "InsertEnter",
	config = function()
		require("supermaven-nvim").setup({
			disable_echo = true,
		})
	end,
}
