return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      preset = 'helix',
      delay = 0,
      filter = function(mapping)
        local lhs = (mapping.lhs or ''):lower()
        return lhs ~= '<c-d>' and lhs ~= '<c-u>'
      end,
      win = {
        row = math.huge,
        col = 0,
        height = { min = 4, max = 0.75 },
      },
      layout = {
        spacing = 1,
        width = { min = 28, max = 40 },
      },
      keys = {
        scroll_down = '<c-d>',
        scroll_up = '<c-u>',
      },
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-...> ',
          M = '<M-...> ',
          D = '<D-...> ',
          S = '<S-...> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
    },
  },
}
