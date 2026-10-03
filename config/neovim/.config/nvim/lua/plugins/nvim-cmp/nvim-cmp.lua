return {
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter' },
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
    },
    opts = function()
      local cmp = require 'cmp'
      return {
        completion = {
          autocomplete = {
            cmp.TriggerEvent.TextChanged,
          },
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources({
          { name = 'obsidian' },
          { name = 'obsidian_new' },
          { name = 'obsidian_tags' },
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'buffer' },
        }),
      }
    end,
    config = function(_, opts)
      require('cmp').setup(opts)
    end,
  },
}
