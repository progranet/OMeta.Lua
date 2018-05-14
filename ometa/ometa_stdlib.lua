local tostring, tonumber, select, type, getmetatable, setmetatable, rawget
    = tostring, tonumber, select, type, getmetatable, setmetatable, rawget

local Types = require 'types'
local Any, Array = Types.Any, Types.Array

local utils = require 'utils'
local Streams = require 'streams'
local OMeta = require 'ometa'

local StandardLibrary = OMeta.Grammar {
  
  _grammarName = 'StandardLibrary';
  
  choice = OMeta.Rule {
    name = 'choice';
    behavior = function(input, ...)
      local num = select('#', ...)
      for e = 1, num do
        local pass, res = input:apply(select(e, ...))
        if pass then
          return true, res
        end
      end
      return false
    end;
  };
  
  anything = OMeta.Rule {
    name = 'anything';
    behavior = function(input)
      return input:next()
    end;
    arity = 0,
  };
  
  exactly = OMeta.Rule {
    name = 'exactly';
    behavior = function(input, expression)
      if input.stream._head == expression then
        return input:next()
      else 
        return false, input.stream._head
      end
    end;
    arity = 1,
  };
  
  subsequence = OMeta.Rule {
    name = 'subsequence';
    behavior = function(input, expression)
      local r = input.stream:subsequence(#expression)
      if r ~= expression then return false, r end
      local pass, res = input:collect(#r)
      return pass, (res:concat())
    end;
    arity = 1,
  };
  
  notPredicate = OMeta.Rule {
    name = 'notPredicate';
    behavior = function(input, expression)
      local state, pass, res = input.stream, input:apply(expression)
      input.stream = state
      return not pass, res
    end;
    arity = 1,
  };
  
  andPredicate = OMeta.Rule {
    name = 'andPredicate';
    behavior = function(input, expression)
      local state, pass, res = input.stream, input:apply(expression)
      input.stream = state
      return pass, res
    end;
    arity = 1,
  };
  
  optional = OMeta.Rule {
    name = 'optional';
    behavior = function(input, expression)
      local pass, res = input:apply(expression)
      return true, res
    end;
    arity = 1,
  };
  
  many = OMeta.Rule {
    name = 'many';
    behavior = function(input, expression, minimum, maximum)
      local state, res, num = input.stream, Array {}, 0
      while true do
        local pass, r = input:apply(expression)
        if not pass then break end
        num = num + 1
        res[num] = r
      end
      if minimum and num < minimum 
      or maximum and num > maximum then 
        input.stream = state
        return false, res
      end
      return true, res
    end;
    arity = 3,
  };
  
  loop = OMeta.Rule {
    name = 'loop';
    behavior = function(input, expression, times)
      local state = input.stream
      if type(times) ~= 'number' then
        local pass, res = input:apply(times)
        if not pass then return false, res end
        times = res
      end
      local res = Array {}
      for i = 1, times do
        local pass, r = input:apply(expression)
        if not pass then
          input.stream = state
          return false, res
        end
        res[i] = r
      end
      return true, res
    end;
    arity = 2,
  };
  
  consumed = OMeta.Rule {
    name = 'consumed';
    behavior = function(input, expression)
      local idx = input.stream._index
      local pass, res = input:apply(expression)
      if not pass then return false, res end
      res = input.stream._source:sub(idx, input.stream._index - 1, true)
      return true, res
    end;
    arity = 1,
  };
  
  object = OMeta.Rule {
    name = 'object';
    behavior = function(input, array, map)
      local pass, tab = input:next()
      if not pass or type(tab) ~= 'table' then return false, tab end
      local state = input.stream
      input:forTable(tab)
      -- array part ----------------------------
      if array ~= nil then
        local pass, res = input:apply(array)
        if not pass then return false, res end
      end
       -- EOS expected after array part --------
      local pass, res = input:next()
      if pass then return false, res end
      -- map part ------------------------------
      if map ~= nil then
        local pass, res = input:apply(map)
        if not pass then return false, res end
      end
      ------------------------------------------
      input.stream = state
      return true, tab
    end;
    arity = 2,
  };
  
  property = OMeta.Rule {
    name = 'property';
    behavior = function(input, index, expression)
      local state = input.stream
      input:property(index)
      local pass, res = input:apply(expression)
      input.stream = state
      return pass, res
    end;
    arity = 2;
  };
}

return StandardLibrary
