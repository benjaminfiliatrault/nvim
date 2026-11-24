return {
	{
		"huggingface/llm.nvim",
		event = "InsertEnter", -- llm-ls must attach after the initial buffer is loaded.
		opts = {
			model = "qwen2.5-coder:1.5b-base",
			backend = "ollama",
			url = "http://localhost:11434",
			request_body = {
				raw = true, -- Preserve the fill-in-the-middle prompt without a chat template.
				options = {
					num_predict = 64,
					num_ctx = 2048,
					temperature = 0.1,
					stop = { "<|endoftext|>", "<|fim_pad|>" },
				},
			},
			fim = {
				enabled = true,
				prefix = "<|fim_prefix|>",
				middle = "<|fim_middle|>",
				suffix = "<|fim_suffix|>",
			},
			context_window = 2048,
			debounce_ms = 300,
			accept_keymap = "<C-y>",
			dismiss_keymap = "<M-e>",
		},
	},
}
