
local tostring, tonumber, select, type, getmetatable, setmetatable, rawget
    = tostring, tonumber, select, type, getmetatable, setmetatable, rawget

local Types = require 'types'
local class = Types.class
local Any, Array = Types.Any, Types.Array

local asc = require 'abstractsyntax_commons'
local Literal, NilLiteral, BooleanLiteral, NumberLiteral, IntegerLiteral, RealLiteral, StringLiteral, Name, Keyword, Special,
      Node, Statement, Expression, Control, Iterative, Invocation
    = asc.Literal, asc.NilLiteral, asc.BooleanLiteral, asc.NumberLiteral, asc.IntegerLiteral, asc.RealLiteral, asc.StringLiteral, asc.Name, asc.Keyword, asc.Special,
      asc.Node, asc.Statement, asc.Expression, asc.Control, asc.Iterative, asc.Invocation
  
      
local esep, lsep = ', ', '\n'

function Array:toLuaSource()
  return self:applyMethod('toLuaSource')
end

local LastStatement = class {
  abstract = true, 
  name = 'LastStatement', 
  super = {Statement};
}

local Get = class {
  name = 'Get', 
  super = {Expression};
  
  toLuaSource = function(self)
    return self.name:toLuaSource()
  end;
}

local Set = class {
  name = 'Set', 
  super = {Statement};
  
  toLuaSource = function(self)
    local isLocal, names, expressions = self.isLocal, self.names:toLuaSource(), self.expressions:toLuaSource()
    return (isLocal and 'local ' or '') .. names:concat(esep) .. (#expressions ~= 0 and (' = ' .. expressions:concat(esep)) or '')
  end;
}

local Group = class {
  name = 'Group', 
  super = {Expression};

  toLuaSource = function(self)
    return '(' .. self.expression:toLuaSource() .. ')'
  end;
}

local Block = class {
  abstract = true, 
  name = 'Block', 
  super = {Node};
}

local Chunk = class {
  name = 'Chunk', 
  super = {Block};
  
  toLuaSource = function(self)
    return self.statements:toLuaSource():append(''):concat(lsep)
  end;
}

local Do = class {
  name = 'Do', 
  super = {Block, Statement};
  
  toLuaSource = function(self)
    return 'do' .. lsep .. self.block:toLuaSource() .. 'end'
  end;
}

local If = class {
  name = 'If', 
  super = {Block, Control, Statement};
  
  toLuaSource = function(self)
    local elseBlock = self.elseBlock:toLuaSource()
    return 'if ' .. self.expression:toLuaSource() .. ' then' .. lsep .. self.block:toLuaSource() .. self.elseIfs:toLuaSource():concat() .. (#elseBlock ~= 0 and ('else' .. lsep .. elseBlock) or '') .. 'end'
  end;
}

local ElseIf = class {
  name = 'ElseIf', 
  super = {Block, Control, Statement};
  
  toLuaSource = function(self)
    return 'elseif ' .. self.expression:toLuaSource() .. ' then' .. lsep .. self.block:toLuaSource()
  end;
}

local For = class {
  name = 'For', 
  super = {Block, Iterative, Statement};

  toLuaSource = function(self)
    local name, start, stop, step = self.name:toLuaSource(), self.startExpression:toLuaSource(), self.stopExpression:toLuaSource(), self.stepExpression:toLuaSource()
    return 'for ' .. name .. ' = ' .. start .. esep .. stop .. (step == '1' and '' or esep .. step) .. ' do' .. lsep .. self.block:toLuaSource() .. 'end'
  end;
}

local ForIn = class {
  name = 'ForIn', 
  super = {Block, Iterative, Statement};
  
  toLuaSource = function(self)
    return 'for ' .. self.names:toLuaSource():concat(esep) .. ' in ' .. self.expressions:toLuaSource():concat(esep) .. ' do' .. lsep .. self.block:toLuaSource() .. 'end'
  end;
}

local While = class {
  name = 'While', 
  super = {Block, Control, Iterative, Statement};
  
  toLuaSource = function(self)
    return 'while ' .. self.expression:toLuaSource() .. ' do' .. lsep .. self.block:toLuaSource() .. 'end'
  end;
}

local Repeat = class {
  name = 'Repeat', 
  super = {Block, Control, Iterative, Statement};
  
  toLuaSource = function(self)
    return 'repeat' .. lsep .. self.block:toLuaSource() .. 'until ' .. self.expression:toLuaSource() .. ''
  end;
}

local Function = class {
  abstract = true, 
  name = 'Function', 
  super = {Block};
  
  toLuaSource = function(self, dec)
    local variableArguments, arguments = self.variableArguments, self.arguments:toLuaSource()
    if variableArguments then arguments:append('...') end
    return dec .. '(' .. arguments:concat(', ') .. ')' .. lsep .. self.block:toLuaSource() .. 'end'
  end;
}

local VariableArguments = class {
  name = 'VariableArguments', 
  super = {Expression};
  
  toLuaSource = function(self)
    return '...'
  end;
}

local MethodStatement = class {
  name = 'MethodStatement', 
  super = {Function, Statement};
  
  toLuaSource = function(self)
    return Function.toLuaSource(self, 'function ' .. self.context:toLuaSource():concat('.') .. ':' .. self.name:toLuaSource())
  end;
}

local FunctionStatement = class {
  name = 'FunctionStatement', 
  super = {Function, Statement};
  
  toLuaSource = function(self)
    local isLocal = self.isLocal
    return Function.toLuaSource(self, isLocal and 'local function ' .. self.name:toLuaSource() or 'function ' .. self.context:toLuaSource():concat('.'))
  end;
}

local FunctionExpression = class {
  name = 'FunctionExpression', 
  super = {Function, Expression};
  
  toLuaSource = function(self)
    return Function.toLuaSource(self, 'function ')
  end;
}

local Return = class {
  name = 'Return', 
  super = {LastStatement};
  
  toLuaSource = function(self)
    return 'return ' .. self.expressions:toLuaSource():concat(esep)
  end;
}

local Break = class {
  name = 'Break', 
  super = {LastStatement};
  
  toLuaSource = function(self)
    return 'break'
  end;
}

local Call = class {
  name = 'Call', 
  super = {Invocation, Expression, Statement};
  
  toLuaSource = function(self)
    return '' .. self.context:toLuaSource() .. '(' .. self.arguments:toLuaSource():concat(', ') .. ')'
  end;
}

local Send = class {
  name = 'Send', 
  super = {Invocation, Expression, Statement};
  
  toLuaSource = function(self)
    return '' .. self.context:toLuaSource() .. ':' .. self.name:toLuaSource() .. '(' .. self.arguments:toLuaSource():concat(esep) .. ')'
  end;
}

local BinaryOperation = class {
  name = 'BinaryOperation', 
  super = {Invocation, Expression};

  toLuaSource = function(self)
    return '' .. tostring(self.context:toLuaSource()) .. ' ' .. self.name:toLuaSource() .. ' ' .. tostring(self.arguments:toLuaSource()[1]) .. ''
  end;
}

local UnaryOperation = class {
  name = 'UnaryOperation', 
  super = {Invocation, Expression};
  
  toLuaSource = function(self)
    local name = self.name:toLuaSource()
    if name == 'not' 
    then return 'not ' .. tostring(self.context:toLuaSource()) .. ''
    else return '' .. self.name:toLuaSource() .. tostring(self.context:toLuaSource()) .. ''
    end
  end;
}

local GetProperty = class {
  name = 'GetProperty', 
  super = {Expression};
  
  toLuaSource = function(self)
    if Name:isInstance(self.index) 
    then return '' .. self.context:toLuaSource() .. '.' .. self.index:toLuaSource() .. ''
    else return '' .. self.context:toLuaSource() .. '[' .. self.index:toLuaSource() .. ']'
    end
  end;
}

local TableConstructor = class {
  name = 'TableConstructor', 
  super = {Expression};
  
  toLuaSource = function(self)
    return '{' .. self.properties:toLuaSource():concat(esep) .. '}'
  end;
}

local SetProperty = class {
  name = 'SetProperty', 
  super = {Node};
  
  toLuaSource = function(self)
    if self.index == nil then return tostring(self.expression:toLuaSource())
    elseif Name:isInstance(self.index) then return self.index:toLuaSource() .. ' = ' .. tostring(self.expression:toLuaSource())
    else return '[' .. self.index:toLuaSource() .. '] = ' .. tostring(self.expression:toLuaSource())
    end
  end;
}

local Goto = class {
  name = 'Goto', 
  super = {Statement};
  
  toLuaSource = function(self)
    return 'goto ' .. self.name:toLuaSource()
  end;
}

local Label = class {
  name = 'Label', 
  super = {Statement};
  
  toLuaSource = function(self)
    return '::' .. self.name:toLuaSource() .. '::'
  end;
}


return {
  LastStatement       = LastStatement,
  Get                 = Get,
  Set                 = Set,
  Group               = Group,
  Block               = Block,
  Chunk               = Chunk,
  Do                  = Do,
  While               = While,
  Repeat              = Repeat,
  If                  = If,
  ElseIf              = ElseIf,
  For                 = For,
  ForIn               = ForIn,
  Function            = Function,
  MethodStatement     = MethodStatement,
  FunctionStatement   = FunctionStatement,
  FunctionExpression  = FunctionExpression,
  Return              = Return,
  Break               = Break,
  Call                = Call,
  Send                = Send,
  BinaryOperation     = BinaryOperation,
  UnaryOperation      = UnaryOperation,
  GetProperty         = GetProperty,
  VariableArguments   = VariableArguments,
  TableConstructor    = TableConstructor,
  SetProperty         = SetProperty;
  
  lua52 = {
    Goto                = Goto,
    Label               = Label;
  }
}
