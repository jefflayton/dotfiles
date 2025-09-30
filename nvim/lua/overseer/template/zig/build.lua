local overseer = require("overseer")
return {
	name = "Zig Build",
	builder = function()
		return {
			cmd = { "zig", "build" },
		}
	end,
	tags = { overseer.TAG.BUILD },
}
