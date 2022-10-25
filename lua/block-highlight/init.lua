local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

local br = [[
["(" ")" "[" "]" "{" "}"]  @bracket
]]

local function rec_brackets(starting_node, query_captures)
	if starting_node == nil then
		return nil
	end
	local parents_table = {}

	for _, node in query_captures:iter_captures(starting_node) do
		local potential_parent = ts_utils.is_parent(node:parent(), starting_node)
		if potential_parent then
			table.insert(parents_table, node)
		end
	end
	if next(parents_table) == nil then
		return rec_brackets(starting_node:parent(), query_captures)
	else
		return parents_table
	end
end

function M.update_selection(start_row, start_col, end_row, end_col)
	local selection_mode = "charwise"
	local buf = 0
	-- Start visual selection in appropriate mode
	local v_table = { charwise = "v", linewise = "V", blockwise = "<C-v>" }
	---- Call to `nvim_replace_termcodes()` is needed for sending appropriate
	---- command to enter blockwise mode
	local mode_string = vim.api.nvim_replace_termcodes(v_table[selection_mode] or selection_mode, true, true, true)
	vim.cmd("normal! " .. mode_string)
	vim.fn.setpos(".", { buf, start_row, start_col, 0 })
	vim.cmd("normal! o")
	vim.fn.setpos(".", { buf, end_row, end_col, 0 })
end

M.select = function(mode)
	mode = mode or "around"
	local starting_node = ts_utils.get_node_at_cursor()
	if starting_node == nil then
		return
	end

	local ft = vim.bo.filetype
	if ft == nil then
		return
	end

	ft = ft:gsub("react", "")

	local query = vim.treesitter.parse_query(ft, br)

	local surrounding_nodes
	if starting_node:type() == "string" then
		surrounding_nodes = { starting_node, starting_node }
	else
		surrounding_nodes = rec_brackets(starting_node, query)
	end

	if surrounding_nodes == nil then
		return
	elseif #surrounding_nodes ~= 2 then
		return
	else
		local start_node = surrounding_nodes[1]
		local end_node = surrounding_nodes[2]

		local start_row, start_col, _ = start_node:start()
		local end_row, end_col, _ = end_node:end_()
		start_row = start_row + 1
		end_row = end_row + 1
		start_col = start_col + 1

		if mode == "inside" then
			start_col = start_col + 1
			end_col = end_col - 1
		end
		M.update_selection(start_row, start_col, end_row, end_col)
	end
end

M.select()

return M
