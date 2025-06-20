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

    telescope.setup({
      pickers = {
        oldfiles = {
          cwd_only = true,
        },
        find_files = {
          hidden = true, -- show dotfiles
          no_ignore = true, -- bypass .gitignore/etc
          -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
          -- find_command = {
          --   "rg",
          --   "--files",
          --   "--hidden",
          --   "--no-ignore",
          --   "--glob",
          --   "!**/.git/*",
          --   "--glob",
          --   "!**/node_modules/*",
          -- },
        },
        live_grep = {
          mappings = {
            i = {
              ["<c-f>"] = custom_pickers.actions.set_extension,
              ["<c-d>"] = custom_pickers.actions.set_folders,
            },
          },
          additional_args = function()
            return { "--hidden" }
          end,
        },
      },
      defaults = {
        file_ignore_patterns = { "^.git/", "node_modules/" },
        layout_config = {
          preview_width = 0.5,
          width = 0.9, -- Set width to 90% of the editor
          -- You can also set the height dimensionally
          height = 0.85, -- Set height to 85% of the editor
        },
        path_display = { "truncate" },
        mappings = {
          n = {
            -- I'm used to closing buffers with "d" from bufexplorer
            ["d"] = actions.delete_buffer,
            -- I'm also used to quitting bufexplorer with q instead of escape
            ["<esc>"] = actions.close,
            -- I probably should use ctrl+key but since I use these already in
            -- lazygit they'll stay like this for now
            ["J"] = actions.preview_scrolling_down,
            ["K"] = actions.preview_scrolling_up,
            -- available only on telescope night
            -- ["H"] = require("telescope.actions").preview_scrolling_left,
            -- ["L"] = require("telescope.actions").preview_scrolling_right,
          },
          i = {
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<esc>"] = actions.close,
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["J"] = actions.preview_scrolling_down,
            ["K"] = actions.preview_scrolling_up,
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
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

    keymap.set("n", "<leader>gg", "<cmd>AdvancedGitSearch<CR>", { desc = "AdvancedGitSearch" })
    keymap.set("n", "<leader>gc", "<cmd>Telescope git_bcommits<cr>", { desc = "Fuzzy find file git commits" })
    keymap.set("n", "<leader>gh", "<cmd>Telescope git_commits<cr>", { desc = "Fuzzy project file git commits" })
    keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Fuzzy find git branches" })
    keymap.set("n", "<leader>gs", "<cmd>Telescope git_stash<cr>", { desc = "Fuzzy find stash" })
    keymap.set("n", "<leader>gf", "<cmd>Telescope git_status<cr>", { desc = "Fuzzy find changed files" })
  end,
}
