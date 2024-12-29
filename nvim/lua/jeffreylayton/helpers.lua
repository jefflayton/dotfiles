return {
	list_aux_tools = function(tools)
		local list = {}
		for _, v in pairs(tools) do
			if v ~= "typescript" then
				for _, f in pairs(v) do
					table.insert(list, f)
				end
			end
		end
		return list
	end,
}
