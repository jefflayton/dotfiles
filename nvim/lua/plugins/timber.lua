return {
	"Goose97/timber.nvim",
	version = "*",
	event = "VeryLazy",
	opts = {
		log_templates = {
			default = {
				zig = [[std.debug.print("%log_target: {}\n", .{%log_target});]],
			},
		},
	},
}
