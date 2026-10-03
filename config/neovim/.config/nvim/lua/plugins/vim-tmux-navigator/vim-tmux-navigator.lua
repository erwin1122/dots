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
      -- vim-herdr-navigation is deployed by dots to
      -- ~/.config/herdr/plugins/vim-herdr-navigation (vendored there, not
      -- in ~/src), so this works on fresh installs.
      dofile(vim.fn.expand('~/.config/herdr/plugins/vim-herdr-navigation/editor/nvim.lua'))
    end,
  },
}
