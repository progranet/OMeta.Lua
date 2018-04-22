package.path = './model/?.lua;./ometa/?.lua;./lib/?.lua;./?.lua;' .. package.path

local tostring, tonumber, select, type, getmetatable, setmetatable, rawget
    = tostring, tonumber, select, type, getmetatable, setmetatable, rawget

local Types = require 'types'
local dataType, class = Types.dataType, Types.class
local Any, Array = Types.Any, Types.Array

local Streams = require 'streams'

local utils = require 'utils'

local unpack = unpack or table.unpack

local Record = dataType {
  name = 'Record',
  super = {};
}

local _idn = 0
local cache = {}
local OMeta

OMeta = {
  
  use = function(grammar)
    local om = cache[grammar]
    if not om then
      om = OMeta.Input {grammar = grammar}
      cache[grammar] = om
    end
    return om
  end;
  
  _do = function(oast, trans)
    local last = require('ometa_ast2lua_ast_' .. (trans or 'reference')).toLuaAst(oast)
    local lsrc = require 'lua_ast2source'.trans:matchMixed(last)
    local gmod = loadstring(lsrc)
    return gmod()
  end;
  
  doFile = function(path, trans)
    local oast = require 'ometa_lua_grammar'.OMetaInLuaGrammar.block:matchFile(path)
    return OMeta._do(oast, trans)
  end;
  
  doString = function(str, trans)
    local oast = require 'ometa_lua_grammar'.OMetaInLuaGrammar.block:matchString(str)
    return OMeta._do(oast, trans)
  end;
}

OMeta.Input = class {

  name = 'Input', 
  super = {Any};

  memoizeParameters = false;
  
  apply = function(self, ruleImpl)
    
    _idn = _idn + 1
    local entryState = self.stream
    
    if type(ruleImpl) == 'function' then
      --print(self.stream._index, _idn, 'native fn' .. string.rep(' ', 16), self.stream._head)
      local pass, result = ruleImpl(self)
      if not pass then self.stream = entryState end
      _idn = _idn - 1
      return pass, result
    end
    
    local behavior = ruleImpl.behavior
    if not behavior then
      -- "plain" type as a rule
      --print(self.stream._index, _idn, ruleImpl.name .. string.rep(' ', 25 - #ruleImpl.name), self.stream._head)
      _idn = _idn - 1
      if ruleImpl:isInstance(self.stream._head) then 
        return self:next()
      end
      return false, self.stream._head
    end
    
    return self:_memoize(ruleImpl, entryState, entryState, entryState)
  end,
  
  applyWithArgs = function(self, ruleImpl, ...)

    _idn = _idn + 1
    local entryState = self.stream
    
    if type(ruleImpl) == 'function' then
      --print(self.stream._index, _idn, 'native fn' .. string.rep(' ', 16), self.stream._head, 'args:', ...)
      local pass, result = ruleImpl(self, ...)
      if not pass then self.stream = entryState end
      _idn = _idn - 1
      return pass, result
    end
    
    local behavior = ruleImpl.behavior
    if not behavior then
      -- expected behavior not yet specified
      --print(self.stream._index, _idn, ruleImpl.name .. string.rep(' ', 25 - #ruleImpl.name), self.stream._head, 'args:', ...)
      print('warning:', 'object does not implement rule behavior', ruleImpl)
      _idn = _idn - 1
      return false
    end

    local argsn = select('#', ...)
    local fnarity = ruleImpl.arity and ruleImpl.arity ~= -1 and ruleImpl.arity or argsn
    --print(self.stream._index, _idn, ruleImpl.name .. string.rep(' ', 25 - #ruleImpl.name), self.stream._head, 'args (' .. tostring(fnarity) .. '/' .. tostring(argsn) .. '):', ...)
    if fnarity < argsn then
      self.stream = self.stream:prepend(argsn - fnarity, select(fnarity + 1, ...))
    end
    
    if fnarity ~= 0 and not self.memoizeParameters then
      local pass, result = behavior(self, ...)
      if not pass then self.stream = entryState end
      _idn = _idn - 1
      return pass, result
    end

    return self:_memoize(ruleImpl, entryState, 
                                   self.stream, 
                                   fnarity == 0 and self.stream or self.stream:prepend(fnarity, ...), ...)
  end,
  
  _memoize = function(self, ruleImpl, entryState, undoState, memoState, ...)
    ruleImpl.count = ruleImpl.count + 1
    local record = memoState.memo[ruleImpl]
    if record == nil then
      record = Record {
        failer = true,
        failerUsed = false
      }
      memoState.memo[ruleImpl] = record
      local pass, result = ruleImpl.behavior(self, ...)
      if not pass then 
        self.stream = entryState
        _idn = _idn - 1
        return false, result 
      end
      record.pass       = pass
      record.result     = result
      record.nextState  = self.stream
      record.failer     = false
      if record.failerUsed then
        local sentinelState = self.stream
        while true do
          self.stream = undoState
          local pass, result = ruleImpl.behavior(self, ...)
          if not pass 
              or self.stream == sentinelState 
              then break 
          end
          record.pass       = pass
          record.result     = result
          record.nextState  = self.stream
        end
      end
    else
      ruleImpl.hits = ruleImpl.hits + 1
      if record.failer then
        record.failerUsed = true
        _idn = _idn - 1
        return false
      end
      ruleImpl.cache = ruleImpl.cache + 1
    end
    self.stream = record.nextState
    _idn = _idn - 1
    return record.pass, record.result
  end,

  applyForeign = function(self, target, ruleImpl)
    local input = OMeta.use(target)
    input.stream = self.stream
    local pass, result = input:apply(ruleImpl)
    if not pass then return false, result end
    self.stream = input.stream
    return pass, result
  end,

  applyForeignWithArgs = function(self, target, ruleImpl, ...)
    local input = OMeta.use(target)
    input.stream = self.stream
    local pass, result = input:applyWithArgs(ruleImpl, ...)
    if not pass then return false, result end
    self.stream = input.stream
    return pass, result
  end,
  
  next = function(self)
    local result = self.stream:head()
    if result == nil then return false end
    self.stream = self.stream:tail()
    return true, result
  end,

  collect = function(self, count)
    local result, tl = Array {}, self.stream
    for i = 1, count do
      local hd = tl:head()
      if hd == nil then return false, result end
      result[i], tl = hd, tl:tail()
    end
    self.stream = tl
    return true, result
  end;
  
  match = function(self, ruleImpl, ...)
    local pass, result
    if select('#', ...) == 0 then
      pass, result = self:apply(ruleImpl)
    else
      pass, result = self:applyWithArgs(ruleImpl, ...)
    end
    if not pass then
      local stream = self.stream
      while stream.tl ~= nil do
        stream = stream.tl
      end
      if type(stream._source) == 'string' then
        print(stream._source:sub(1, stream._index))
      end
      error('match failed at: ' .. self.stream._index .. ' - ' .. stream._index)
    end
    return result
  end;
  
  forString = function(self, str)
    self.stream = Streams.StringInputStream:new(str)
    return self
  end,
  
  forTable = function(self, tab)
    self.stream = Streams.TableInputStream:new(tab)
    return self
  end,
  
  forMixed = function(self, ...)
    local res, num, len = Array {}, 0, select('#', ...)
    for si = 1, len do
      local element = select(si, ...)
      if element ~= nil then
        if type(element) == 'string' then
          local last = #element
          while last ~= 0 and element:byte(last) <= 32 do last = last - 1 end
          if last ~= 0 then
            local first = 1
            while element:byte(first) <= 32 do first = first + 1 end
            for sii = first, last do
              num = num + 1
              res[num] = element:sub(sii, sii)
            end
          end
        else
          num = num + 1
          res[num] = element
        end
      end
    end
    self.stream = Streams.TableInputStream:new(res)
    return self
  end,
  
  forFile = function(self, path, binary)
    self.stream = (binary and Streams.BinaryInputStream or Streams.StringInputStream):new(utils.readFile(path))
    return self
  end;
}

OMeta.Grammar = class {
  
  name = 'Grammar',
  super = {Any};  
  
  constructor = function(class, init)
    for k, v in pairs(init) do
      if OMeta.Rule:isInstance(v) then
        v.grammar = init
      end
    end
    return init
  end;
  
  merge = function(self, source)
    for k, mrule in pairs(source) do
      if OMeta.Rule:isInstance(mrule) then
        local lrule = rawget(self, k)
        if lrule == nil then
          lrule = OMeta.Rule {
            name = mrule.name,
            grammar = self,
            arity = mrule.arity,
            behavior = mrule.behavior;
          }
          self[k] = lrule
        else
          if lrule.behavior ~= mrule.behavior then
            local qname = k
            if self._grammarName then qname = self._grammarName .. '::' .. qname end
            print('merge conflict (rule ignored) for ' .. qname)
          end
        end
      end
    end
    return self
  end;
}

OMeta.Rule = class {
  
  name = 'Rule',
  super = {Any};
  
  constructor = function(class, init)
    if init.arity == nil then init.arity = -1 end
    if init.count == nil then init.count = 0 end
    if init.cache == nil then init.cache = 0 end
    if init.hits == nil then init.hits = 0 end
    return init
  end;
  
  matchString = function(self, str, ...)
    return OMeta.use(self.grammar):forString(str):match(self, ...)
  end;
  
  matchTable = function(self, tab, ...)
    return OMeta.use(self.grammar):forTable(tab):match(self, ...)
  end;
  
  matchMixed = function(self, ...)
    return OMeta.use(self.grammar):forMixed(...):match(self)
  end;
  
  matchFile = function(self, path, binary, ...)
    return OMeta.use(self.grammar):forFile(path, binary):match(self, ...)
  end;
}

return OMeta
