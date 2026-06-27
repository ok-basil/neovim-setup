local M = {}

function M.project_root(path, markers)
	local start = path
	if not start or start == "" then
		start = vim.api.nvim_buf_get_name(0)
	end
	if start == "" then
		start = vim.fn.getcwd()
	elseif vim.fn.isdirectory(start) == 0 then
		start = vim.fs.dirname(start)
	end

	return vim.fs.root(start, markers)
end

function M.is_wordpress_project(path)
	return M.project_root(path, { "wp-config.php", "wp-content", "wp-includes", "wp-admin" }) ~= nil
end

return M
