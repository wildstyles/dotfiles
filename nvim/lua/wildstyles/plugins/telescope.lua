return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "debugloop/telescope-undo.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- https://www.reddit.com/r/neovim/comments/xj784v/comment/ip8051r/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    local custom_pickers = require("wildstyles.telescope_custom_pickers")

    local telescopeConfig = require("telescope.config")
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

    -- I want to search in hidden/dot files.
    table.insert(vimgrep_arguments, "--hidden")
    -- I don't want to search in the `.git` directory.
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/yarn.lock")

    telescope.setup({
      pickers = {
        oldfiles = {
          cwd_only = true,
        },
        find_files = {
          -- find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          hidden = true, -- show dotfiles
          no_ignore = true, -- bypass .gitignore/etc
        },
        live_grep = {
          disable_coordinates = true,
          mappings = {
            i = {
              -- I want c-r mapping here to restore last search string
              ["<c-e>"] = custom_pickers.actions.set_extension,
              ["<c-f>"] = custom_pickers.actions.set_folders,
            },
          },
        },
      },
      extensions = {
        undo = {
          use_delta = true,
          use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
          side_by_side = false,
          vim_diff_opts = { ctxlen = vim.o.scrolloff },
          entry_format = "state #$ID, $STAT, $TIME",
          mappings = {
            i = {
              ["<C-cr>"] = require("telescope-undo.actions").yank_additions,
              ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
              ["<cr>"] = require("telescope-undo.actions").restore,
            },
          },
        },
      },
      defaults = {
        vimgrep_arguments = vimgrep_arguments,
        file_ignore_patterns = { "^.git/", "node_modules/" },
        layout_config = {
          preview_width = 0.5,
          width = 0.9,
          height = 0.85,
        },
        path_display = { "truncate" },
        mappings = {
          n = {
            ["d"] = actions.delete_buffer,
            ["<esc>"] = actions.close,
          },
          i = {
            ["<C-Down>"] = function(prompt_bufnr)
              actions.cycle_history_next(prompt_bufnr)
            end,

            ["<C-Up>"] = function(prompt_bufnr)
              local prev = custom_pickers.peek_prev()

              print(vim.inspect(prev), "prev")

              if prev then
                custom_pickers.filters.extension = prev.extension
                custom_pickers.filters.directories = prev.directories
                custom_pickers.run_live_grep(prev.query)
              end
            end,
            ["<esc>"] = actions.close,
            ["<C-t>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("advanced_git_search")
    telescope.load_extension("undo")
    telescope.load_extension("neoclip")
    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", custom_pickers.live_grep, { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

    keymap.set("n", "<leader>gg", "<cmd>AdvancedGitSearch<CR>", { desc = "AdvancedGitSearch" })
    keymap.set("n", "<leader>gc", "<cmd>Telescope git_bcommits<cr>", { desc = "Fuzzy find file git commits" })
    keymap.set("n", "<leader>gh", "<cmd>Telescope git_commits<cr>", { desc = "Fuzzy project file git commits" })
    keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Fuzzy find git branches" })
    keymap.set("n", "<leader>gs", "<cmd>Telescope git_stash<cr>", { desc = "Fuzzy find stash" })
    keymap.set("n", "<leader>gf", "<cmd>Telescope git_status<cr>", { desc = "Fuzzy find changed files" })
  end,
}
