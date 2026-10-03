local function git_sync_vault()
  local vault = vim.fn.expand '~/denkarium'

  local function run_git(args)
    local cmd = { 'git', '-C', vault }
    vim.list_extend(cmd, args)
    local result = vim.system(cmd, { text = true }):wait()
    local output = ((result.stdout or '') .. (result.stderr or '')):gsub('%s+$', '')
    return result.code, output
  end

  local code = run_git { 'rev-parse', '--is-inside-work-tree' }
  if code ~= 0 then
    vim.notify('Obsidian vault is not a git repository: ' .. vault, vim.log.levels.ERROR)
    return
  end

  local has_changes = false
  code, output = run_git { 'status', '--porcelain' }
  if code ~= 0 then
    vim.notify('Git sync failed while checking status:\n' .. output, vim.log.levels.ERROR)
    return
  end
  if output ~= '' then
    has_changes = true
    code, output = run_git { 'add', '-A' }
    if code ~= 0 then
      vim.notify('Git sync failed while staging changes:\n' .. output, vim.log.levels.ERROR)
      return
    end

    local msg = 'Vault sync ' .. os.date('%Y-%m-%d %H:%M')
    code, output = run_git { 'commit', '-m', msg }
    if code ~= 0 then
      vim.notify('Git sync failed while committing:\n' .. output, vim.log.levels.ERROR)
      return
    end
  end

  code, output = run_git { 'pull', '--rebase', '--autostash' }
  if code ~= 0 then
    vim.notify('Git sync failed while pulling:\n' .. output, vim.log.levels.ERROR)
    return
  end

  code, output = run_git { 'push' }
  if code ~= 0 then
    vim.notify('Git sync failed while pushing:\n' .. output, vim.log.levels.ERROR)
    return
  end

  if has_changes then
    vim.notify('Obsidian Git Sync complete: committed, pulled, and pushed.', vim.log.levels.INFO)
  else
    vim.notify('Obsidian Git Sync complete: pulled and pushed (no local changes).', vim.log.levels.INFO)
  end
end

local function to_filename(name)
  return name:lower():gsub('%s+', '-'):gsub('[^%w%-]', '')
end

local function new_note()
  vim.ui.input({ prompt = 'Note name: ' }, function(name)
    if not name or name == '' then return end
    local filename = to_filename(name)
    local path = vim.fn.expand('~/denkarium/00_inbox/') .. filename .. '.md'
    local date = os.date '%Y-%m-%d'
    local lines = {
      '---',
      'date: ' .. date,
      'tags: []',
      '---',
      '',
    }
    vim.fn.writefile(lines, path)
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
    vim.cmd 'normal! G'
  end)
end

local function new_note_from_template()
  local template_dir = vim.fn.expand '~/denkarium/templates'
  local all_files = vim.fn.readdir(template_dir)
  local templates = vim.tbl_filter(function(f)
    return f:match '%.md$'
  end, all_files)

  vim.ui.select(templates, { prompt = 'Select template:' }, function(template)
    if not template then return end
    vim.ui.input({ prompt = 'Note name: ' }, function(name)
      if not name or name == '' then return end
      local filename = to_filename(name)
      local path = vim.fn.expand('~/denkarium/00_inbox/') .. filename .. '.md'
      local content = vim.fn.readfile(template_dir .. '/' .. template)
      local date = os.date '%Y-%m-%d'
      content = vim.tbl_map(function(line)
        return line:gsub('{{date}}', date):gsub('{{title}}', name)
      end, content)
      vim.fn.writefile(content, path)
      vim.cmd('edit ' .. vim.fn.fnameescape(path))
      vim.cmd 'normal! G'
    end)
  end)
end

return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = false,
    ft = 'markdown',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      ui = {
        enable = false,
        update_debounce = 200,
        max_file_length = 5000,
      },
      workspaces = {
        {
          name = 'Denkarium',
          path = '~/denkarium',
        },
      },
      notes_subdir = '00_inbox',
      new_notes_location = 'notes_subdir',
      note_id_func = function(title)
        if title ~= nil then
          return title:lower():gsub('%s+', '-'):gsub('[^%w%-]', '')
        end
        return tostring(os.time())
      end,
      daily_notes = {
        folder = '01_daily/2026',
        date_format = '%d_%m_%Y',
        default_tags = {},
        template = 'daily_template',
      },
      templates = {
        folder = 'templates',
        date_format = '%d_%m_%Y',
        time_format = '%H:%M',
      },
      attachments = {
        img_folder = 'assets',
      },
      picker = {
        name = 'telescope.nvim',
      },
      sort_by = 'modified',
      sort_reversed = true,
      open_notes_in = 'current',
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      mappings = {
        ['gf'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ['<leader>ox'] = {
          action = function()
            return require('obsidian').util.toggle_checkbox()
          end,
          opts = { buffer = true, desc = 'Obsidian: Toggle checkbox state' },
        },
      },
      disable_frontmatter = true,
    },
    config = function(_, opts)
      require('obsidian').setup(opts)

      -- Inject frontmatter into any new markdown file created inside the vault
      vim.api.nvim_create_autocmd('BufNewFile', {
        pattern = vim.fn.expand '~/denkarium' .. '/**/*.md',
        callback = function()
          local date = os.date '%Y-%m-%d'
          vim.api.nvim_buf_set_lines(0, 0, 0, false, {
            '---',
            'date: ' .. date,
            'tags: []',
            '---',
            '',
          })
        end,
      })
    end,
    keys = {
      { '<leader>oo', '<cmd>ObsidianQuickSwitch<CR>', desc = 'Obsidian: Quick switch' },
      { '<leader>on', new_note, desc = 'Obsidian: New note' },
      { '<leader>oN', new_note_from_template, desc = 'Obsidian: New note from template' },
      { '<leader>os', '<cmd>ObsidianDailies -10 0<CR>', desc = 'Obsidian: Daily notes (last 10 days)' },
      { '<leader>oS', '<cmd>ObsidianSearch<CR>', desc = 'Obsidian: Search content' },
      { '<leader>ot', '<cmd>ObsidianToday<CR>', desc = 'Obsidian: Today' },
      { '<leader>oy', '<cmd>ObsidianYesterday<CR>', desc = 'Obsidian: Yesterday' },
      { '<leader>om', '<cmd>ObsidianTomorrow<CR>', desc = 'Obsidian: Tomorrow' },
      { '<leader>ob', '<cmd>ObsidianBacklinks<CR>', desc = 'Obsidian: Backlinks' },
      { '<leader>ol', '<cmd>ObsidianFollowLink<CR>', desc = 'Obsidian: Follow link' },
      { '<leader>oL', '<cmd>ObsidianLinks<CR>', desc = 'Obsidian: Links in current note' },
      { '<leader>or', '<cmd>ObsidianRename --dry-run<CR>', desc = 'Obsidian: Rename note (dry run)' },
      { '<leader>oR', '<cmd>ObsidianRename<CR>', desc = 'Obsidian: Rename note' },
      { '<leader>oT', '<cmd>ObsidianTemplate<CR>', desc = 'Obsidian: Insert template' },
      { '<leader>oc', '<cmd>ObsidianToggleCheckbox<CR>', desc = 'Obsidian: Cycle checkbox state' },
      { '<leader>oO', '<cmd>ObsidianOpen<CR>', desc = 'Obsidian: Open in app' },
      { '<leader>og', git_sync_vault, desc = 'Obsidian: Git Sync' },
      { '<leader>oW', '<cmd>ObsidianWorkspace<CR>', desc = 'Obsidian: Switch workspace' },
      { '<leader>o#', '<cmd>ObsidianTags<CR>', desc = 'Obsidian: Find tags' },
      { '<leader>oP', '<cmd>ObsidianPasteImg<CR>', desc = 'Obsidian: Paste image' },
      { '<leader>oa', '<cmd>ObsidianTOC<CR>', desc = 'Obsidian: Table of contents' },
    },
  },
}
