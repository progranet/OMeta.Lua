
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

local RuleApplication = class {
	name = 'RuleApplication',
	super = {Expression};
}

local Binding = class {
	name = 'Binding',
	super = {Statement};
}

local Application = class {
  abstract = true,
  name = 'Application',
  super = {Expression};

  -- provides default transformation 
  -- from specialized OMeta AST nodes
  -- to generic Rule Application nodes
  toRuleApplication = function(self)
    local name = getmetatable(self).type.ruleName
    if not name then
      local nodeName = getmetatable(self).name
      name = nodeName:sub(1, 1):lower() .. nodeName:sub(2)
    end
    local ruleApp = {
      name = Array {Name {name}},
      arguments = nil -- property must be provided in specializations
    }
    self:_asRuleApplication(ruleApp)
    return RuleApplication(ruleApp)
  end,
  
  -- by default each non-abstract subtype must: 
  -- - provide 'arguments' class property containing names of instance properties 
  --    used as sources of rule application arguments
  -- - or provide specialized method for arguments derivation (see Choice class below)
  _asRuleApplication = function(self, ruleApp)
    local nodeType_arguments = getmetatable(self).type.arguments
    ruleApp.arguments = Array {}
    for a = 1, #nodeType_arguments do
      ruleApp.arguments[a] = self[nodeType_arguments[a]]
    end
  end;
}

local Choice = class {
	name = 'Choice',
	super = {Application};
  
  _asRuleApplication = function(self, ruleApp)
    self.arity = #self.nodes
    ruleApp.arguments = self.nodes
    ruleApp._generic = true
  end;
}

local Sequence = class {
	name = 'Sequence',
	super = {Expression};
}

local Anything = class {
	name = 'Anything',
	super = {Application};

  arguments = {};
}

local Exactly = class {
  name = 'Exactly', 
	super = {Application};

  arguments = {'expression'};
}

local Token = class {
  name = 'Token', 
	super = {Application};

  arguments = {'expression'};
}

local Subsequence = class {
  name = 'Subsequence', 
	super = {Application};

  arguments = {'expression'};
}

local Lookahead = class {
  abstract = true,
	name = 'Lookahead',
	super = {Node};
}

local NotPredicate = class {
	name = 'NotPredicate',
	super = {Lookahead, Application};

  arguments = {'expression'};
}

local AndPredicate = class {
	name = 'AndPredicate',
	super = {Lookahead, Application};

  arguments = {'expression'};
}

local Optional = class {
	name = 'Optional',
	super = {Application};

  arguments = {'expression'};
}

local Many = class {
	name = 'Many',
	super = {Application};

  arguments = {'expression', 'minimum', 'maximum'};
}

local Loop = class {
	name = 'Loop',
	super = {Application};

  arguments = {'expression', 'times'};
}

local Consumed = class {
	name = 'Consumed',
	super = {Application};

  arguments = {'expression'};
}

local HostNode = class {
  abstract = true,
	name = 'HostNode',
	super = {Node};
}

local HostStatement = class {
	name = 'HostStatement',
	super = {HostNode, Statement};
}

local HostExpression = class {
	name = 'HostExpression',
	super = {HostNode, Expression};
}

local HostPredicate = class {
	name = 'HostPredicate',
	super = {HostNode, Lookahead, Statement};
}

local Object = class {
	name = 'Object',
	super = {Application};
  
  arguments = {'array', 'map'};
}

local Key = class {
	name = 'Key',
	super = {Expression};
}

local Rule = class {
  abstract = true,
	name = 'Rule',
	super = {Node};
  
  constructor = function(class, init)
    if init.locals == nil then init.locals = Array {} end
    return init
  end
}

local RuleExpression = class {
	name = 'RuleExpression',
	super = {Rule, Expression};
}

local RuleStatement = class {
	name = 'RuleStatement',
	super = {Rule, Statement};
}

local Grammar = class {
  abstract = true,
	name = 'Grammar',
	super = {Node};
}

local GrammarExpression = class {
	name = 'GrammarExpression',
	super = {Grammar, Expression};
}

local GrammarStatement = class {
	name = 'GrammarStatement',
	super = {Grammar, Statement};
}


return {
  Binding             = Binding,
  Choice              = Choice,
  Sequence            = Sequence,
  Application         = Application,
  Exactly             = Exactly,
  Token               = Token,
  Subsequence         = Subsequence,
  Lookahead           = Lookahead,
  NotPredicate        = NotPredicate,
  AndPredicate        = AndPredicate,
  Optional            = Optional,
  Many                = Many,
  Consumed            = Consumed,
  Loop                = Loop,
  Anything            = Anything,
  HostNode            = HostNode,
  HostStatement       = HostStatement,
  HostExpression      = HostExpression,
  HostPredicate       = HostPredicate,
  RuleApplication     = RuleApplication,
  Object              = Object,
  Key                 = Key,
  Rule                = Rule,
  RuleExpression      = RuleExpression,
  RuleStatement       = RuleStatement,
  Grammar             = Grammar,
  GrammarExpression   = GrammarExpression,
  GrammarStatement    = GrammarStatement;
}
