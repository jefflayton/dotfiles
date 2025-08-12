local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

-- TypeScript snippets
return {
	s({ trig = "tc" }, {
		t({ "try {", "" }),
		t({ "", "} catch (" }),
		i(1, "error"),
		t({ ") {", "  " }),
		i(2, "console.error(error)"),
		t({ "", "}" }),
		i(0),
	}),
	s({ trig = "fn", regTrig = true }, {
		t({ "function " }),
		i(1, "name"),
		t("("),
		i(2, "param"),
		t({ ": " }),
		i(3, "type"),
		t({ ") {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
}
