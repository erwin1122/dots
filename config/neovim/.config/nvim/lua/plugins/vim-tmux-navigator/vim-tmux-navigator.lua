return {
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    init = function()
      -- vim-herdr-navigation provides the mappings (falls back to tmux
      -- outside herdr, so this stays the single source of truth).
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      dofile(vim.fn.expand('~/src/vim-herdr-navigation/editor/nvim.lua'))
    end,
  },
}
