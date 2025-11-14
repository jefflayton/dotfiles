local overseer = require("overseer")
return {
	name = "Zig Build & Run",
	builder = function()
		return {
			cmd = { "zig", "build", "run" },
		}
	end,
	tags = { overseer.TAG.BUILD },
}
