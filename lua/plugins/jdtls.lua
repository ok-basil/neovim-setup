local function java_config()
	local jdtls = require("jdtls")

	local root_markers = {
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
		"settings.gradle",
		"settings.gradle.kts",
		".git",
	}
	local root_dir = vim.fs.root(0, root_markers)
	if not root_dir then
		return
	end

	local data_dir = vim.fn.stdpath("data")
	local mason_dir = data_dir .. "/mason"
	local jdtls_dir = mason_dir .. "/packages/jdtls"
	local java_home = vim.env.JAVA_HOME
	if not java_home or java_home == "" then
		java_home = vim.fn.trim(vim.fn.system({ "/usr/libexec/java_home" }))
	end
	local runtime_name = "JavaSE-21"
	if java_home and java_home ~= "" then
		local release_file = java_home .. "/release"
		if vim.fn.filereadable(release_file) == 1 then
			for _, line in ipairs(vim.fn.readfile(release_file)) do
				local version = line:match('^JAVA_VERSION="(%d+)')
				if version then
					runtime_name = "JavaSE-" .. version
					break
				end
			end
		end
	end
	local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
	local workspace_hash = vim.fn.sha256(root_dir)
	local workspace_dir = data_dir .. "/jdtls-workspaces/" .. project_name .. "-" .. workspace_hash

	local bundles = {}
	local java_debug = vim.fn.glob(
		mason_dir .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
		true,
		true
	)
	local java_test = vim.fn.glob(mason_dir .. "/packages/java-test/extension/server/*.jar", true, true)
	vim.list_extend(bundles, java_debug)
	vim.list_extend(bundles, java_test)

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if ok_cmp then
		capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
	end

	local function map(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = true, desc = "Java: " .. desc })
	end

	local config = {
		name = "jdtls",
		cmd = {
			vim.fn.exepath("java"),
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-javaagent:" .. jdtls_dir .. "/lombok.jar",
			"-Xms1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",
			"-jar",
			vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
			"-configuration",
			jdtls_dir .. "/config_mac_arm",
			"-data",
			workspace_dir,
		},
		root_dir = root_dir,
		capabilities = capabilities,
		settings = {
			java = {
				configuration = {
					runtimes = {
						{
							name = runtime_name,
							path = java_home,
							default = true,
						},
					},
				},
				eclipse = {
					downloadSources = true,
				},
				maven = {
					downloadSources = true,
				},
				implementationsCodeLens = {
					enabled = true,
				},
				referencesCodeLens = {
					enabled = true,
				},
				references = {
					includeDecompiledSources = true,
				},
				signatureHelp = {
					enabled = true,
				},
			},
		},
		init_options = {
			bundles = bundles,
		},
		on_attach = function(client, bufnr)
			if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end

			jdtls.setup_dap({ hotcodereplace = "auto" })
			jdtls.setup_dap_main_class_configs()

			map("<leader>jo", jdtls.organize_imports, "Organize imports")
			map("<leader>jv", jdtls.extract_variable, "Extract variable")
			map("<leader>jv", function()
				jdtls.extract_variable(true)
			end, "Extract variable", "x")
			map("<leader>jc", jdtls.extract_constant, "Extract constant")
			map("<leader>jc", function()
				jdtls.extract_constant(true)
			end, "Extract constant", "x")
			map("<leader>jm", function()
				jdtls.extract_method(true)
			end, "Extract method", "x")
			map("<leader>jt", jdtls.test_nearest_method, "Test nearest method")
			map("<leader>jT", jdtls.test_class, "Test class")
			map("<leader>ju", "<cmd>JdtUpdateConfig<cr>", "Update project configuration")
		end,
	}

	jdtls.start_or_attach(config)
end

return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"mfussenegger/nvim-dap",
	},
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = java_config,
		})

		if vim.bo.filetype == "java" then
			java_config()
		end
	end,
}
