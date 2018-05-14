
local tostring, tonumber, select, type, getmetatable, setmetatable, rawget
    = tostring, tonumber, select, type, getmetatable, setmetatable, rawget

function string:at(i)
  return (self:sub(i, i))
end

string.special = '\a\b\f\n\r\t\v\\\"\''

function string:escape()
  local r = ''
  for i = 1, #self do
    local c = self:at(i)
    if string.special:find(c, 1, true) then
      local b = c:byte(1)
      r = r .. '\\' .. string.format('%03d', b)
    else
      r = r .. c
    end
  end
  return r
end

local _unescape_replace = function(b,d) return string.char(tonumber(d)) end
function string:unescape()
  return (self:gsub('(\\)(%d+)', _unescape_replace))
end

function string:lpad(len, char)
  return (char and char:at(1) or ' '):rep(len - #self) .. self
end

function string.interpolate(...)
  local res, len = {}, select('#', ...)
  for si = 1, len - 1, 2 do
    res[si], res[si + 1] = (select(si, ...)), tostring(select(si + 1, ...))
  end
  res[len] = (select(len, ...))
  return (table.concat(res))
end

local function measure(fn)
  local start = os.clock()
  --local res = fn()
  --print(string.format("time: %.3f", os.clock() - start))
  return fn(), os.clock() - start
end

local function existsFile(path)
  local file = io.open(path, "rb")
  if file then
    file:close()
  end
  return file ~= nil
end

local function readFile(path)
  local file = io.open(path, "rb")
  local content = file:read "*a"
  file:close()
  return content
end

local function writeFile(path, content)
  local file = io.open(path, "wb")
  file:write(content)
  file:close()
end

return {
  measure = measure;

  existsFile = existsFile,
  readFile = readFile,
  writeFile = writeFile;
}
