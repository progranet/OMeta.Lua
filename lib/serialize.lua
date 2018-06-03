local tostring, tonumber, select, type, getmetatable, setmetatable, rawget
    = tostring, tonumber, select, type, getmetatable, setmetatable, rawget

local id, _toTree, used
_toTree = function(levelprefix, key, value, term)
  local kind = type(value)
  local meta = kind == 'table' and used[value]
  local copy
  if meta == nil then
    id = id + 1
    copy = {}
    local al, ml = 0, 0
    for k, v in pairs(value) do
      if type(k) == 'number' then 
        al = al + 1
        copy[k] = v
      elseif type(k) == 'string' then 
        if k:sub(1, 1) ~= '_' then
          ml = ml + 1 
          copy[k] = v
        end
      end
    end
    meta = {
      id = id,
      al = al,
      ml = ml;
    }
    used[value] = meta
  end
  local mt = kind == 'table' and getmetatable(value)
  local nt = mt and mt.name and mt.name or kind
  if kind == 'table' then 
    nt = nt .. '@' .. meta.id .. ' (#' .. tostring(meta.al) .. ':' .. tostring(meta.ml) .. ')'
  else
    nt = nt .. ' = ' .. tostring(value)
  end
  local void = kind ~= 'table' or (meta.al + meta.ml == 0)
  local result = {}
  result[1] = (void and (term and '\205' or '-') or (term and '\203' or '+')) .. ' ' .. key .. ' : ' .. nt
  if kind ~= 'table' then
    
  elseif copy == nil then
    if not void then
      result[2] = term and '\192--' or '...'
    end
    result[#result] = result[#result] .. ' <recursion>'
  else
    for k, v in pairs(copy) do
      local hasnext = next(copy, k) ~= nil
      local pf = hasnext and (term and '\195\196' or '+-') or (term and '\192\196' or '--')
--      if type(v) == 'table' then
        local lp = levelprefix .. (hasnext and (term and '\179 ' or '| ') or '  ')
        local nested = _toTree(lp, k, v, term)
        result[#result + 1] = pf .. table.concat(nested, '\n' .. lp)
--      else
--        result[#result + 1] = pf .. (term and '\205' or '-') .. ' ' .. k .. ': ' .. tostring(v)
--      end
    end
  end
  return result
end

local function toTree(instance, term)
  term, used, id = term or __term, {}, 0
  return table.concat(_toTree('', '<self>', instance, term), '\n')
end

return {
  toSimpleTree  = function(instance) return toTree(instance, false) end;
  toTermTree    = function(instance) return toTree(instance, true) end;
}
