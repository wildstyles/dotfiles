local Path = require("plenary.path")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local transform_mod = require("telescope.actions.mt").transform_mod
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local os_sep = Path.path.sep
local pickers = require("telescope.pickers")
local scan = require("plenary.scandir")

local M = {}

---Keep track of the active extension and folders for `live_grep`
local live_grep_filters = {
  ---@type nil|string
  extension = nil,
  ---@type nil|string[]
  directories = nil,
}

local live_grep_history = {
  entries = {}, -- list of { query = string, extension = string?, directories = {string}? }
  idx = 0, -- 1-based pointer into entries
}

local function record_live_grep(query)
  live_grep_history.idx = live_grep_history.idx + 1
  live_grep_history.entries[live_grep_history.idx] = {
    query = query,
    extension = live_grep_filters.extension,
    directories = live_grep_filters.directories,
  }
end

local function peek_prev()
  print(vim.inspect(live_grep_history), "history")
  if live_grep_history.idx > 1 then
    return live_grep_history.entries[live_grep_history.idx - 1]
  end
end

---Run `live_grep` with the active filters (extension and folders)
---@param current_input ?string
local function run_live_grep(current_input)
  local cwd = vim.loop.cwd() .. os_sep
  local dir_list = live_grep_filters.directories
  local title_dirs = ""

  if dir_list then
    -- build a list of relative paths
    local rels = {}
    for _, abs in ipairs(dir_list) do
      -- remove the cwd prefix
      local rel = abs:gsub("^" .. vim.pesc(cwd), "")
      -- also strip any trailing sep
      rel = rel:gsub(os_sep .. "$", "")
      table.insert(rels, rel)
    end
    title_dirs = " (" .. table.concat(rels, ", ") .. ")"
  end

  if current_input ~= nil then
    record_live_grep(current_input)
  end

  require("wildstyles.telescope_pretty_pickers").pretty_grep_picker({
    picker = "live_grep",
    options = {
      prompt_title = "Live Grep" .. title_dirs,
      additional_args = live_grep_filters.extension and function()
        return { "-g", "*." .. live_grep_filters.extension }
      end,
      search_dirs = live_grep_filters.directories,
      default_text = current_input,
    },
  })
end

M.actions = transform_mod({
  ---Ask for a file extension and open a new `live_grep` filtering by it
  set_extension = function(prompt_bufnr)
    local current_input = action_state.get_current_line()

    vim.ui.input({ prompt = "*." }, function(input)
      if input == nil then
        return
      end

      --I want to restore it as well on 'C-Down'
      live_grep_filters.extension = input

      actions.close(prompt_bufnr)
      run_live_grep(current_input)
    end)
  end,
  ---Ask the user for a folder and olen a new `live_grep` filtering by it
  set_folders = function(prompt_bufnr)
    local current_input = action_state.get_current_line()

    local data = {}
    scan.scan_dir(vim.loop.cwd(), {
      hidden = true,
      only_dirs = true,
      respect_gitignore = true,
      on_insert = function(entry)
        if not entry:find(os_sep .. ".git") then
          table.insert(data, entry .. os_sep)
        end
      end,
    })
    table.insert(data, 1, "." .. os_sep)

    actions.close(prompt_bufnr)
    local startup_complete = false
    pickers
      .new({}, {
        prompt_title = "Folders for Live Grep",
        finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file({}) }),
        previewer = conf.file_previewer({}),
        sorter = conf.file_sorter({}),
        on_complete = {
          function(picker)
            if startup_complete then
              return
            end

            local dirs = live_grep_filters.directories or {}
            local i = 1

            for entry in picker.manager:iter() do
              local path = (entry.value or entry[1]):gsub(os_sep .. "$", "")

              if vim.tbl_contains(dirs, path) then
                picker:add_selection(picker:get_row(i))
              end

              i = i + 1
            end

            startup_complete = true
          end,
        },
        attach_mappings = function(prompt_bufnr, map)
          map("i", "<Esc>", function()
            live_grep_filters.directories = nil
            actions.close(prompt_bufnr)
            run_live_grep(current_input)
            return true
          end)

          action_set.select:replace(function()
            local current_picker = action_state.get_current_picker(prompt_bufnr)

            local dirs = {}
            local selections = current_picker:get_multi_selection()
            if vim.tbl_isempty(selections) then
              table.insert(dirs, action_state.get_selected_entry().value)
            else
              for _, selection in ipairs(selections) do
                table.insert(dirs, selection.value)
              end
            end
            live_grep_filters.directories = dirs

            actions.close(prompt_bufnr)
            run_live_grep(current_input)
          end)
          return true
        end,
      })
      :find()
  end,
})

---Small wrapper over `live_grep` to first reset our active filters
M.live_grep = function()
  live_grep_filters.extension = nil
  live_grep_filters.directories = nil

  run_live_grep()
end

M.run_live_grep = run_live_grep
M.filters = live_grep_filters
M.peek_prev = peek_prev

return M
