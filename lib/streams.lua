
local tostring, tonumber, select, type, getmetatable, setmetatable, rawget
    = tostring, tonumber, select, type, getmetatable, setmetatable, rawget

local Types = require 'types'
local class = Types.class
local Any, Array = Types.Any, Types.Array

local
  InputStream,
    ListInputStream,
      StringInputStream,
      BinaryInputStream,
      TableInputStream,
    InputStreamEnd,
    PrependedInputStream,
    PropertyInputStream

InputStream = class {
  
  abstract = true,
  name = 'InputStream', 
  super = {Any};
  
  head = function(self)
    return self._head
  end,
  
  tail = function(self)
    return self._tail
  end,
  
  -- prepends current position with element(s)
  prepend = function(self, num, ...)
    local tail = self
    for i = num, 1, -1 do
      tail = PrependedInputStream.new(select(i, ...), tail)
    end
    return tail
  end,
  
  -- returns 'count' elements from current position
  subsequence = function(self, count)
    return nil
  end,
  
  -- matches pattern against content at current position
  pattern = function(self, pat)
    return nil
  end;
}

local nilSentinel = {}

PrependedInputStream = class {
  
  name = 'PrependedInputStream', 
  super = {InputStream};

  new = function(head, tail)
    local index = head == nil and nilSentinel or head
    local prepended = tail.prefix[index]
    if prepended ~= nil then
      return prepended
    end
    prepended = PrependedInputStream {
      memo    = {},
      prefix  = {},
      _source = tail._source,
      _index  = tail._index,
      _head   = head,
      _tail   = tail
    }
    tail.prefix[index] = prepended
    return prepended
  end
}

ListInputStream = class {
  
  abstract = true,
  name = 'ListInputStream', 
  super = {InputStream};
  
  new = function(type, source, index)
    index = index or 1
    local init = {
      memo    = {},
      prefix  = {},
      _source = source,
      _index  = index
    }
    if index > #source then
      type = InputStreamEnd
    end
    init._head = type._getHead(init)
    --init.type = type
    return (type(init))
  end,
  
  tail = function(self)
    if self._tail == nil then
      self._tail = getType(self):new(self._source, self._index + 1)
    end
    return self._tail
  end,
  
  property = function(self, index)
    local prop = self._source[index]
    if Array:isInstance(prop) then
      return (TableInputStream:new(prop))
    end
    return (PropertyInputStream.new(self, index))
  end;
}

StringInputStream = class {
  
  name = 'StringInputStream', 
  super = {ListInputStream};
  
  subsequence = function(self, count)
    return (self._source:sub(self._index, self._index + count - 1))
  end,
  
  pattern = function(self, pat)
    return (self._source:match('^' .. pat, self._index))
  end,
  
  _getHead = function(self)
    return (self._source:sub(self._index, self._index))
  end;
}

BinaryInputStream = class {

  name = 'BinaryInputStream', 
  super = {ListInputStream};
  
  _getHead = function(self)
    return (self._source:sub(self._index, self._index):byte())
  end;
}

TableInputStream = class {

  name = 'TableInputStream', 
  super = {ListInputStream};
  
  subsequence = function(self, count)
    return (self._source:sub(self._index, self._index + count - 1, true))
  end,
  
  _getHead = function(self)
    return self._source[self._index]
  end;
}

InputStreamEnd = class {

  abstract = true,
  name = 'InputStreamEnd', 
  super = {ListInputStream};
  
  _getHead = function(self)
    return nil
  end,
  
  head = function(self)
    return nil
  end,
  
  tail = function(self)
    return nil
  end
}

PropertyInputStream = class {

  name = 'PropertyInputStream', 
  super = {InputStream};
  
  new = function(tail, index)
    local init = {
      memo    = {},
      prefix  = {},
      _source = tail._source,
      --_head   = tail._source[index],
      _index  = index,
      _tail   = tail
    }
    local type
    if tail._source[index] == nil then
      type = InputStreamEnd
    else
      type = PropertyInputStream
    end
    init._head = type._getHead(init)
    return (type(init))
  end;
  
  _getHead = function(self)
    return self._source[self._index]
  end,
  
  property = function(self, index)
    local prop = self._source[index]
    if Array:isInstance(prop) then
      return (TableInputStream:new(prop))
    end
    return (PropertyInputStream.new(self._tail, index))
  end;
}

return {
  InputStream = InputStream,
  ListInputStream = ListInputStream,
  StringInputStream = StringInputStream,
  BinaryInputStream = BinaryInputStream,
  TableInputStream = TableInputStream,
  PrependedInputStream = PrependedInputStream,
  PropertyInputStream = PropertyInputStream;
  InputStreamEnd = InputStreamEnd;
}
