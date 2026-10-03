return {
  {
    'jiaoshijie/undotree',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      position = 'right',
    },
    keys = {
      { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>", desc = 'Toggle Undotree' },
    },
  },
}
