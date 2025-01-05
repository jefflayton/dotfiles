local helpers = {}

helpers.parse_tools = function(tools)
	local unique_tools_set = {}
	local unique_tools_list = {}

	for _, v in pairs(tools) do
		for _, f in ipairs(v) do
			if not unique_tools_set[f] then
				unique_tools_set[f] = true
			end
		end
	end

	for tool in pairs(unique_tools_set) do
		table.insert(unique_tools_list, tool)
	end

	return unique_tools_list
end

return helpers
