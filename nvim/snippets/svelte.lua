local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s({ trig = "if" }, {
		t({ "{#if " }),
		i(1, "condition"),
		t({ "}", "\t" }),
		i(2, "<p>thing</p>"),
		t({ "", "{/if}" }),
	}),
	s({ trig = "script" }, {
		t({ '<script lang="ts">', "\t" }),
		i(1),
		t({ "", "</script>" }),
	}),
	s({ trig = "snippet" }, {
		t({ "{#snippet " }),
		i(1, "func"),
		t({ "()}", "\t" }),
		i(2),
		t({ "", "{/snippet}" }),
	}),
	s({ trig = "each" }, {
		t({ "{#each " }),
		i(1, "expression"),
		t({ " as " }),
		i(2, "name"),
		t({ "}", "\t" }),
		i(3),
		t({ "", "{/each}" }),
	}),
}
