return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    opts = {},
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    keys = {
      { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
    },
  },
}
