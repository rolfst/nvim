local treesitter_context_status_ok, treesitter_context = pcall(require, "treesitter-context")
if not treesitter_context_status_ok then
	return
end
treesitter_context.setup({
	enable = true,
	max_lines = 0,
	trim_scope = "outer",
	min_window_height = 0,
	patterns = {
		default = {
			"class",
			"function",
			"method",
			"for",
			"while",
			"if",
			"switch",
			"case",
		},
		tex = {
			"chapter",
			"section",
			"subsection",
			"subsubsection",
		},
		rust = {
			"impl_item",
			"struct",
			"enum",
		},
		scala = {
			"object_definition",
		},
		vhdl = {
			"process_statement",
			"architecture_body",
			"entity_declaration",
		},
		markdown = {
			"section",
		},
		elixir = {
			"anonymous_function",
			"arguments",
			"block",
			"do_block",
			"list",
			"map",
			"tuple",
			"quoted_content",
		},
		json = {
			"pair",
		},
		yaml = {
			"block_mapping_pair",
		},
	},
	exact_patterns = {},
	zindex = 20,
	mode = "cursor",
	separator = nil,
})
