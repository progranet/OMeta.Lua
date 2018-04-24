
local tostring, tonumber, select, type, getmetatable, setmetatable, rawget
    = tostring, tonumber, select, type, getmetatable, setmetatable, rawget

local Types = require('types')
local primitive, dataType, class = Types.primitive, Types.dataType, Types.class
local Any, Array = Types.Any, Types.Array

local Literal = dataType {
  abstract = true,
	name = 'Literal',
	super = {Any};

  toLuaSource = function(self)
    return tostring(self[1])
  end;
}

local NilLiteral = dataType {
	name = 'NilLiteral',
	super = {Literal};
}

local BooleanLiteral = dataType {
	name = 'BooleanLiteral',
	super = {Literal};
}

local NumberLiteral = dataType {
  abstract = true,
	name = 'NumberLiteral',
	super = {Literal};
}

local RealLiteral = dataType {
	name = 'RealLiteral',
	super = {NumberLiteral};
}

local IntegerLiteral = dataType {
	name = 'IntegerLiteral',
	super = {NumberLiteral};
}

local CharSequenceLiteral = dataType {
  abstract = true,
  name = 'CharSequenceLiteral',
  super = {Literal};
}

local StringLiteral = dataType {
	name = 'StringLiteral',
	super = {CharSequenceLiteral};
  
  constructor = function(class, init)
    if init.ldelim == nil then
      init.ldelim = '\''
      init.rdelim = '\''
    end
    --TODO: general solution for "special" characters
    if init.ldelim == '[[' and init[1] == ']' then
      init.ldelim = '[=['
      init.rdelim = ']=]'
    end
    return init
  end;
  
  toLuaSource = function(self)
    return (self.ldelim or '\'') .. self[1] .. (self.rdelim or '\'')
  end;
}

local Sequence = dataType {
	name = 'Sequence',
	super = {CharSequenceLiteral};
}

local Name = dataType {
	name = 'Name',
	super = {CharSequenceLiteral};
}

local Keyword = dataType {
	name = 'Keyword',
	super = {CharSequenceLiteral};
}

local Special = dataType {
	name = 'Special',
	super = {CharSequenceLiteral};
}

local Comment = dataType {
	name = 'Comment',
	super = {Literal};

  toLuaSource = function(self)
    return ''
  end;
}

local Space = dataType {
	name = 'Space',
	super = {Literal};
}


local id = 0

local Node = class {

  abstract = true,
  name = 'Node',
  super = {Any};
  
  constructor = function(class, init)
    id = id + 1
    init._id = '_' .. class.name:lower() .. tostring(id)
    return init
  end;

  collectNodes = function(self, type, filter)
    local nodes = Array {}
    if type:isInstance(self) then 
      if not filter or filter(self) then
        nodes[1] = self
      end
    end
    for k, v in pairs(self) do
      if Node:isInstance(v) then
        nodes:appendAll(v:collectNodes(type, filter))
      elseif Array:isinstance(v) then
        for k = 1, #v do
          local vk = v[k]
          if Node:isInstance(vk) then
            nodes:appendAll(vk:collectNodes(type, filter))
          end
        end
      end
    end
    return nodes
  end;
}

local Statement = class {
  abstract = true, 
  name = 'Statement', 
  super = {Node};
}

local Expression = class {
  abstract = true, 
  name = 'Expression', 
  super = {Node};
}

local Control = class {
  abstract = true, 
  name = 'Control', 
  super = {Node};
}

local Iterative = class {
  abstract = true, 
  name = 'Iterative', 
  super = {Node};
}

local Invocation = class {
  abstract = true, 
  name = 'Invocation', 
  super = {Node};
}


return {
  Node = Node,
  Statement = Statement,
  Expression = Expression,
  Control = Control,
  Iterative = Iterative,
  Invocation = Invocation;
  
  Literal = Literal,
  NilLiteral = NilLiteral,
  BooleanLiteral = BooleanLiteral,
  NumberLiteral = NumberLiteral,
  IntegerLiteral = IntegerLiteral,
  RealLiteral = RealLiteral,
  StringLiteral = StringLiteral,
  Name = Name,
  Keyword = Keyword,
  Special = Special;
}
