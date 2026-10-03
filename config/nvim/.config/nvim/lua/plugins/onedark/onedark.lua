return {
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'darker',
        transparent = false,
        term_colors = true,
        ending_tildes = true,
        cmp_itemkind_reverse = false,
        toggle_style_key = nil,
        toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' },
        code_style = {
          comments = 'none',
          keywords = 'none',
          functions = 'none',
          strings = 'none',
          variables = 'none',
        },
        lualine = {
          transparent = false,
        },
        colors = {
          bg0 = '#13161A',
          green = '#00916C',
        },
        diagnostics = {
          darker = true,
          undercurl = true,
          background = true,
        },
      }
      require('onedark').load()
    end,
  },
}
