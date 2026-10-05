-- Kompatibilitaets-Shim fuer Neovim >= 0.12.
--
-- Bis Neovim 0.11 konnten Predicates/Direktiven mit `{ all = false }` registriert
-- werden; ihr Handler bekam dann pro Capture einen einzelnen TSNode. Seit 0.12 ist
-- diese Option entfernt und `match[capture_id]` ist immer eine Liste von Nodes.
-- Plugins, die noch den alten Vertrag erwarten (z. B. nvim-treesitter auf dem
-- eingefrorenen master-Branch), scheitern dadurch mit
-- "attempt to call method 'range' (a nil value)".
--
-- Der Shim stellt das alte Verhalten wieder her: er nimmt - wie Neovim 0.10/0.11 -
-- den letzten Node der Liste.

local query = require 'vim.treesitter.query'

if vim.fn.has 'nvim-0.12' == 0 or query.__all_false_compat then
  return
end

local function unwrap_single_nodes(handler)
  return function(match, ...)
    local single = {}
    for capture_id, nodes in pairs(match) do
      single[capture_id] = type(nodes) == 'table' and nodes[#nodes] or nodes
    end
    return handler(single, ...)
  end
end

local function patch(register_fn_name)
  local original = query[register_fn_name]

  query[register_fn_name] = function(name, handler, opts)
    if type(opts) == 'table' and opts.all == false then
      handler = unwrap_single_nodes(handler)
    end
    return original(name, handler, opts)
  end
end

patch 'add_predicate'
patch 'add_directive'

query.__all_false_compat = true
