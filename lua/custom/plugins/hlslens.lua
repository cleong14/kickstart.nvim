-- https://github.com/kevinhwang91/nvim-hlslens
return function()
  local hlslens = require("hlslens")

  -- nvim-ufo integration
  -- https://github.com/kevinhwang91/nvim-ufo
  local function nN(char)
    local ok, winid = hlslens.nNPeekWithUFO(char)
    if ok and winid then
      -- Safe to override buffer scope keymaps remapped by ufo,
      -- ufo will restore previous buffer keymaps before closing preview window
      -- Type <CR> will switch to preview window and fire `trace` action
      vim.keymap.set('n', '<CR>', function()
        local keyCodes = vim.api.nvim_replace_termcodes('<Tab><CR>', true, false, true)
        vim.api.nvim_feedkeys(keyCodes, 'im', false)
      end, {buffer = true})
    end
  end
  vim.keymap.set({'n', 'x'}, 'n', function() nN('n') end)
  vim.keymap.set({'n', 'x'}, 'N', function() nN('N') end)

  -- Customize virtual text
  -- https://github.com/kevinhwang91/nvim-hlslens#customize-virtual-text
  local function override_lens(render, posList, nearest, idx, relIdx)
    local sfw = vim.v.searchforward == 1
    local indicator, text, chunks
    local absRelIdx = math.abs(relIdx)
    if absRelIdx > 1 then
      indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and '▲' or '▼')
    elseif absRelIdx == 1 then
      indicator = sfw ~= (relIdx == 1) and '▲' or '▼'
    else
      indicator = ''
    end

    local lnum, col = unpack(posList[idx])
    if nearest then
      local cnt = #posList
      if indicator ~= '' then
        text = ('[%s %d/%d]'):format(indicator, idx, cnt)
      else
        text = ('[%d/%d]'):format(idx, cnt)
      end
      chunks = {{' ', 'Ignore'}, {text, 'HlSearchLensNear'}}
    else
      text = ('[%s %d]'):format(indicator, idx)
      chunks = {{' ', 'Ignore'}, {text, 'HlSearchLens'}}
    end
    render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
  end

  -- hlslens setup
  hlslens.setup({
    override_lens = override_lens,
  })

  -- nvim-scrollbar integration
  -- https://github.com/petertriho/nvim-scrollbar
  require("scrollbar.handlers.search").setup({
    -- hlslens config overrides
    auto_enable = true,
    enable_incsearch = true,
    calm_down = false,
    nearest_only = false,
    nearest_float_when = 'always',
    float_shadow_blend = 50,
    virt_priority = 100,
    override_lens = override_lens,
  })

  -- run `:nohlsearch` and export results to quickfix
  vim.keymap.set({'n', 'x'}, '<Space>L', function()
    vim.schedule(function()
      if require('hlslens').exportLastSearchToQuickfix() then
        vim.cmd('cw')
      end
    end)
    return ':noh<CR>'
  end, {expr = true})

  -- vim-visual-multi integration
  -- https://github.com/kevinhwang91/nvim-hlslens#vim-visual-multi
  local config
  local lensBak

  local overrideLens = function(render, posList, nearest, idx, relIdx)
    local _ = relIdx
    local lnum, col = unpack(posList[idx])

    local text, chunks
    if nearest then
      text = ('[%d/%d]'):format(idx, #posList)
      chunks = {{' ', 'Ignore'}, {text, 'VM_Extend'}}
    else
      text = ('[%d]'):format(idx)
      chunks = {{' ', 'Ignore'}, {text, 'HlSearchLens'}}
    end
    render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
  end

  Vim_visual_multi_start = function()
    if not hlslens then
      return
    else
      config = require('hlslens.config')
      lensBak = config.override_lens
      config.override_lens = overrideLens
      hlslens.start()
    end
  end

  Vim_visual_multi_exit = function()
    if not hlslens then
      return
    else
      config.override_lens = lensBak
      hlslens.start()
    end
  end

  vim.cmd([[
    aug VMlens
      au!
      au User visual_multi_start lua Vim_visual_multi_start()
      au User visual_multi_exit lua Vim_visual_multi_exit()
    aug END
  ]])
end
