return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      require('mini.files').setup()
      vim.keymap.set('n', '<leader>e', function()
        local mini_files = require 'mini.files'
        if not mini_files.close() then
          mini_files.open(vim.api.nvim_buf_get_name(0), false)
        end
      end, { desc = '[E]xplorer' })

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
