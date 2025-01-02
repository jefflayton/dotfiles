local M = {}

M.list_aux_tools = function(tools)
	local list = {}

	for _, v in pairs(tools) do
		for _, f in pairs(v) do
			if type(f) ~= "string" and not vim.tbl_contains(list, f) then
				table.insert(list, f)
			end
		end
	end

	print(type(list))
	return list
end

return M
