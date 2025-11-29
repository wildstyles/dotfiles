-- Plugin which allows to send HHTP requests. Alternative to postman

local function scroll_to_end_of_file()
	local buf = vim.api.nvim_get_current_buf()
	local total_lines = vim.api.nvim_buf_line_count(buf)
	-- Check if the last line of the buffer is empty
	local last_line_content =
		vim.api.nvim_buf_get_lines(buf, total_lines - 1, total_lines, false)[1]

	local lines_to_add
	if last_line_content == "" then
		lines_to_add = { "" }
	else
		lines_to_add = { "", "" }
	end

	vim.api.nvim_buf_set_lines(
		buf,
		total_lines,
		total_lines,
		false,
		lines_to_add
	)

	vim.api.nvim_win_set_cursor(0, { total_lines + #lines_to_add, 0 })
end

local function filter_headers(headers, allowed_headers)
	if not allowed_headers then
		return headers
	end

	local function is_allowed_header(header_key)
		for _, allowed_key in ipairs(allowed_headers) do
			if header_key == allowed_key then
				return true
			end
		end
		return false
	end

	return vim.tbl_filter(is_allowed_header, headers)
end

local function print_http_spec(spec, curl, allowed_headers)
	local lines = {}

	table.insert(lines, "### " .. curl)
	table.insert(lines, " ")

	local url = spec.method .. " " .. spec.url .. " " .. "HTTP/1.1"
	-- url = spec.http_version ~= "" and url .. " " .. spec.http_versio or url

	table.insert(lines, url)

	local headers = filter_headers(vim.tbl_keys(spec.headers), allowed_headers)
	table.sort(headers)

	vim.iter(headers):each(function(header)
		table.insert(lines, header .. ": " .. spec.headers[header])
	end)

	_ = #spec.cookie > 0 and table.insert(lines, "Cookie: " .. spec.cookie)

	if #spec.body > 0 then
		table.insert(lines, "")

		vim.iter(spec.body):each(function(line)
			line = spec.body[#spec.body] and line or line .. "&"
			table.insert(lines, line)
		end)
	end

	scroll_to_end_of_file()
	vim.api.nvim_put(lines, "l", false, false)
end

local function paste_from_curl(allowed_headers)
	local CURL_PARSER = require("kulala.parser.curl")
	local clipboard = vim.fn.getreg("+")
	local spec, curl = CURL_PARSER.parse(clipboard)

	print_http_spec(spec, curl, allowed_headers)
	vim.cmd("normal! zz")
	vim.cmd("update")
	vim.cmd("normal! 2j")
end

return {
	"mistweaverco/kulala.nvim",
	keys = {
		{ "<leader>Rs", desc = "Send request" },
		{ "<leader>Ra", desc = "Send all requests" },
		{ "<leader>Rb", desc = "Open scratchpad" },
	},
	ft = { "http", "rest" },
	opts = {
		request_timout = 10000,
		-- global_keymaps = true,
		global_keymaps = {
			["Send all requests"] = false,
			-- ["Select environment"] = false,
			["Open kulala"] = false,
			["Download GraphQL schema"] = false,
			["Toggle headers/body"] = false,
			["Open scratchpad"] = false,
			["Close window"] = false,
			["Jump to next request"] = false,
			["Jump to previous request"] = false,
			["Copy as cURL"] = {
				"C",
				function()
					require("kulala").copy()
				end,
				ft = { "http", "rest" },
			},
			["Paste from curl stripped"] = {
				"p",
				function()
					paste_from_curl({
						"accept",
						"authorization",
						"content-type",
					})
				end,
				ft = { "http", "rest" },
			},
			["Paste from curl"] = {
				"c",
				function()
					paste_from_curl()
				end,
				ft = { "http", "rest" },
			},
			["Send request"] = { -- sets global mapping
				"<CR>",
				function()
					local filename = vim.fn.expand("%:t") -- Get just the filename
					local extension = filename:match("^.+(%..+)$") -- Using Lua pattern matching to extract the extension

					if extension:find(".http") then
						require("kulala").run()
					end
				end,
				mode = { "n", "v" }, -- optional mode, default is n
				desc = "Send request changed description", -- optional description, otherwise inferred from the key
			},
		},
		global_keymaps_prefix = "<leader>k",
		kulala_keymaps_prefix = "",
	},
}
