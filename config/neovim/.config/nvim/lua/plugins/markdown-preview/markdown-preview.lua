return {
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_browserfunc = 'MkdpOpenInBrowser'
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_images_path = '/home/arch/denkarium'

      vim.cmd [[
        function! MkdpOpenInBrowser(url) abort
          let l:winurl = substitute(a:url, '&', '^&', 'g')
          call jobstart([
                \ '/mnt/c/Windows/System32/cmd.exe',
                \ '/C',
                \ 'start',
                \ '',
                \ l:winurl,
                \ ], { 'detach': v:true })
        endfunction
      ]]
    end,
    keys = {
      { '<leader>ov', '<cmd>MarkdownPreview<CR>', desc = 'View in Browser' },
    },
  },
}
