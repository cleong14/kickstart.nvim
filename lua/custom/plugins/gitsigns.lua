return function()
  require("gitsigns").setup({
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = "│",
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn",
      },
      change = {
        hl = "GitSignsChange",
        text = "│",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      delete = {
        hl = "GitSignsDelete",
        text = "_",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = "‾",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      changedelete = {
        hl = "GitSignsChange",
        text = "~",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      untracked = {
        hl = 'GitSignsAdd',
        text = '┆',
        numhl = 'GitSignsAddNr',
        linehl = 'GitSignsAddLn'
      },
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = { interval = 1000, follow_files = true },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '  <author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    yadm = {
      enable = false
    },
    diff_opts = {
      internal = true, -- If luajit is present
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      -- Actions
      map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR> ')
      map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR> ')
      map('n', '<leader>hS', gs.stage_buffer, { desc = 'Gitsigns stage_buffer' })
      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Gitsigns undo_stage_hunk' })
      map('n', '<leader>hR', gs.reset_buffer, { desc = 'Gitsigns reset_buffer' })
      map('n', '<leader>hp', gs.preview_hunk, { desc = 'Gitsigns preview_hunk' })
      map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = 'Gitsigns blame_line' })
      map('n', '<leader>tb', gs.toggle_current_line_blame , { desc = 'Gitsigns toggle_current_line_blame' })
      map('n', '<leader>hd', gs.diffthis, { desc = 'Gitsigns diffthis' })
      map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Gitsigns diffthis deleted' })
      map('n', '<leader>td', gs.toggle_deleted, { desc = 'Gitsigns toggle_deleted' })

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR> ')
    end
  })
  require("scrollbar.handlers.gitsigns").setup()
end
