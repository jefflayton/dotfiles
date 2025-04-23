local filetypes = {
	"bib",
	"gitcommit",
	"org",
	"plaintex",
	"rst",
	"rnoweb",
	"tex",
	"pandoc",
	"quarto",
	"rmd",
	"context",
	"xhtml",
	"mail",
	"text",
}

return {
	cmd = { "ltex-ls" },
	filetypes = filetypes,
	settings = {
		ltex = {
			enabled = filetypes,
			additionalRules = {
				languageModel = "~/ngrams/",
			},
		},
	},
	root_markers = { ".git" },
}
