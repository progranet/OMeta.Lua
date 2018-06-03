local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local Types = require('types')
local Any, Array = Types.Any, Types.Array
local OMeta = require('ometa')
local utils = require('utils')
local asc = require('abstractsyntax_commons')
local Literal, NilLiteral, BooleanLiteral, NumberLiteral, IntegerLiteral, RealLiteral, StringLiteral, Name, Keyword, Special, Node, Statement, Expression, Control, Iterative, Invocation = asc.Literal, asc.NilLiteral, asc.BooleanLiteral, asc.NumberLiteral, asc.IntegerLiteral, asc.RealLiteral, asc.StringLiteral, asc.Name, asc.Keyword, asc.Special, asc.Node, asc.Statement, asc.Expression, asc.Control, asc.Iterative, asc.Invocation
local las = require('lua_abstractsyntax')
local Get, Set, Group, Block, Chunk, Do, While, Repeat, If, ElseIf, For, ForIn, Function, MethodStatement, FunctionStatement, FunctionExpression, Return, Break, LastStatement, Call, Send, BinaryOperation, UnaryOperation, GetProperty, VariableArguments, TableConstructor, SetProperty, Goto, Label = las.Get, las.Set, las.Group, las.Block, las.Chunk, las.Do, las.While, las.Repeat, las.If, las.ElseIf, las.For, las.ForIn, las.Function, las.MethodStatement, las.FunctionStatement, las.FunctionExpression, las.Return, las.Break, las.LastStatement, las.Call, las.Send, las.BinaryOperation, las.UnaryOperation, las.GetProperty, las.VariableArguments, las.TableConstructor, las.SetProperty, las.lua52.Goto, las.lua52.Label
local Commons = require('commons')
local Streams = require('streams')
local Aux = require('auxiliary')
local lsep, esep = '\n', ', '
local LuaAstToSourceTranslator = OMeta.Grammar({_grammarName = 'LuaAstToSourceTranslator', trans = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input.stream._head ~= nil) then
return false
end
return input:applyWithArgs(Aux.apply, getType(input.stream._head), input.grammar.unexpected)
end)
end, arity = 0, name = 'trans'}), unexpected = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return error('unexpected node: ' .. tostring(input.stream._head))
end)
end, arity = 0, name = 'unexpected'}), [NilLiteral] = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(input.grammar.anything)) then
return false
end
return true, 'nil'
end)
end, arity = 0, name = 'NilLiteral'}), [BooleanLiteral] = OMeta.Rule({behavior = function (input)
local value, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, value = input:apply(input.grammar.anything)
return __pass__, value
end)
end, nil)) then
return false
end
return true, string.interpolate([[]], value, [[]])
end)
end, arity = 0, name = 'BooleanLiteral'}), [RealLiteral] = OMeta.Rule({behavior = function (input)
local value, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, value = input:apply(input.grammar.anything)
return __pass__, value
end)
end, nil)) then
return false
end
return true, string.interpolate([[]], value, [[]])
end)
end, arity = 0, name = 'RealLiteral'}), [IntegerLiteral] = OMeta.Rule({behavior = function (input)
local value, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, value = input:apply(input.grammar.anything)
return __pass__, value
end)
end, nil)) then
return false
end
return true, string.interpolate([[]], value, [[]])
end)
end, arity = 0, name = 'IntegerLiteral'}), [Name] = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.anything)
if not (__pass__) then
return false
end
return __pass__, __result__
end)
end, nil)) then
return false
end
return true, __result__
end)
end, arity = 0, name = 'Name'}), [Keyword] = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.anything)
if not (__pass__) then
return false
end
return __pass__, __result__
end)
end, nil)) then
return false
end
return true, __result__
end)
end, arity = 0, name = 'Keyword'}), [Special] = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.anything)
if not (__pass__) then
return false
end
return __pass__, __result__
end)
end, nil)) then
return false
end
return true, __result__
end)
end, arity = 0, name = 'Special'}), [StringLiteral] = OMeta.Rule({behavior = function (input)
local ldelim, __pass__, rdelim, value
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, value = input:apply(input.grammar.anything)
return __pass__, value
end)
end, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, ldelim = input:applyWithArgs(input.grammar.property, 'ldelim', function (input)
return input:applyWithArgs(input.grammar.optional, input.grammar.anything)
end)
if not (__pass__) then
return false
end
__pass__, rdelim = input:applyWithArgs(input.grammar.property, 'rdelim', function (input)
return input:applyWithArgs(input.grammar.optional, input.grammar.anything)
end)
return __pass__, rdelim
end)
end)) then
return false
end
return true, string.interpolate([[]], ldelim or "'", [[]], value, [[]], rdelim or "'", [[]])
end)
end, arity = 0, name = 'StringLiteral'}), [Get] = OMeta.Rule({behavior = function (input)
local name, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
return __pass__, name
end)
end)) then
return false
end
return true, name
end)
end, arity = 0, name = 'Get'}), [Set] = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local names, __pass__, expressions
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.property, 'isLocal', true)) then
return false
end
__pass__, names = input:applyWithArgs(input.grammar.property, 'names', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans, 1)
end)
if not (__pass__) then
return false
end
__pass__, expressions = input:applyWithArgs(input.grammar.property, 'expressions', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans, 1)
end)
return __pass__, expressions
end)
end)) then
return false
end
return true, string.interpolate([[local ]], names:concat(esep), [[ = ]], expressions:concat(esep), [[]])
end, function (input)
local names, __pass__
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.property, 'isLocal', true)) then
return false
end
__pass__, names = input:applyWithArgs(input.grammar.property, 'names', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans, 1)
end)
return __pass__, names
end)
end)) then
return false
end
return true, string.interpolate([[local ]], names:concat(esep), [[]])
end, function (input)
local names, __pass__, expressions
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, names = input:applyWithArgs(input.grammar.property, 'names', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans, 1)
end)
if not (__pass__) then
return false
end
__pass__, expressions = input:applyWithArgs(input.grammar.property, 'expressions', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans, 1)
end)
return __pass__, expressions
end)
end)) then
return false
end
return true, string.interpolate([[]], names:concat(esep), [[ = ]], expressions:concat(esep), [[]])
end)
end, arity = 0, name = 'Set'}), [Chunk] = OMeta.Rule({behavior = function (input)
local statements, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, statements = input:applyWithArgs(input.grammar.property, 'statements', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return __pass__, statements
end)
end)) then
return false
end
return true, statements:append(''):concat(lsep)
end)
end, arity = 0, name = 'Chunk'}), [Group] = OMeta.Rule({behavior = function (input)
local expression, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
return __pass__, expression
end)
end)) then
return false
end
return true, string.interpolate([[(]], expression, [[)]])
end)
end, arity = 0, name = 'Group'}), [Do] = OMeta.Rule({behavior = function (input)
local block, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return __pass__, block
end)
end)) then
return false
end
return true, string.interpolate([[do]], lsep, [[]], block, [[end]])
end)
end, arity = 0, name = 'Do'}), [While] = OMeta.Rule({behavior = function (input)
local __pass__, condition, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, condition = input:applyWithArgs(input.grammar.property, 'condition', input.grammar.trans)
return __pass__, condition
end)
end)) then
return false
end
return true, string.interpolate([[while ]], condition, [[ do]], lsep, [[]], block, [[end]])
end)
end, arity = 0, name = 'While'}), [Repeat] = OMeta.Rule({behavior = function (input)
local __pass__, condition, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, condition = input:applyWithArgs(input.grammar.property, 'condition', input.grammar.trans)
return __pass__, condition
end)
end)) then
return false
end
return true, string.interpolate([[repeat]], lsep, [[]], block, [[until ]], condition, [[]])
end)
end, arity = 0, name = 'Repeat'}), [If] = OMeta.Rule({behavior = function (input)
local elseIfs, block, __pass__, elseBlock, condition
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, condition = input:applyWithArgs(input.grammar.property, 'condition', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, elseIfs = input:applyWithArgs(input.grammar.property, 'elseIfs', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (__pass__) then
return false
end
__pass__, elseBlock = input:applyWithArgs(input.grammar.property, 'elseBlock', input.grammar.trans)
return __pass__, elseBlock
end)
end)) then
return false
end
return true, string.interpolate([[if ]], condition, [[ then]], lsep, [[]], block, [[]], elseIfs:concat(), [[]], (#elseBlock ~= 0 and (string.interpolate([[else]], lsep, [[]], elseBlock, [[]])) or string.interpolate([[]])), [[end]])
end)
end, arity = 0, name = 'If'}), [ElseIf] = OMeta.Rule({behavior = function (input)
local condition, __pass__, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, condition = input:applyWithArgs(input.grammar.property, 'condition', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return __pass__, block
end)
end)) then
return false
end
return true, string.interpolate([[elseif ]], condition, [[ then]], lsep, [[]], block, [[]])
end)
end, arity = 0, name = 'ElseIf'}), [For] = OMeta.Rule({behavior = function (input)
local stepExpression, block, __pass__, startExpression, name, stopExpression
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, startExpression = input:applyWithArgs(input.grammar.property, 'startExpression', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, stopExpression = input:applyWithArgs(input.grammar.property, 'stopExpression', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, stepExpression = input:applyWithArgs(input.grammar.property, 'stepExpression', input.grammar.trans)
return __pass__, stepExpression
end)
end)) then
return false
end
return true, string.interpolate([[for ]], name, [[ = ]], startExpression, [[]], esep, [[]], stopExpression, [[]], (stepExpression == '1' and string.interpolate([[]]) or string.interpolate([[]], esep, [[]], stepExpression, [[]])), [[ do]], lsep, [[]], block, [[end]])
end)
end, arity = 0, name = 'For'}), [ForIn] = OMeta.Rule({behavior = function (input)
local names, __pass__, expressions, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, names = input:applyWithArgs(input.grammar.property, 'names', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (__pass__) then
return false
end
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, expressions = input:applyWithArgs(input.grammar.property, 'expressions', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return __pass__, expressions
end)
end)) then
return false
end
return true, string.interpolate([[for ]], names:concat(esep), [[ in ]], expressions:concat(esep), [[ do]], lsep, [[]], block, [[end]])
end)
end, arity = 0, name = 'ForIn'}), [MethodStatement] = OMeta.Rule({behavior = function (input)
local arguments, variableArguments, block, __pass__, name, context
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, context = input:applyWithArgs(input.grammar.property, 'context', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (__pass__) then
return false
end
__pass__, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (__pass__) then
return false
end
__pass__, variableArguments = input:applyWithArgs(input.grammar.property, 'variableArguments', input.grammar.anything)
if not (__pass__) then
return false
end
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return __pass__, block
end)
end)) then
return false
end
return true, string.interpolate([[function ]], context:concat('.'), [[:]], name, [[(]], (variableArguments and arguments:append('...') or arguments):concat(esep), [[)]], lsep, [[]], block, [[end]])
end)
end, arity = 0, name = 'MethodStatement'}), [FunctionStatement] = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local arguments, variableArguments, block, __pass__, name
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.property, 'isLocal', true)) then
return false
end
__pass__, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (__pass__) then
return false
end
__pass__, variableArguments = input:applyWithArgs(input.grammar.property, 'variableArguments', input.grammar.anything)
if not (__pass__) then
return false
end
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return __pass__, block
end)
end)) then
return false
end
return true, string.interpolate([[local function ]], name, [[(]], (variableArguments and arguments:append('...') or arguments):concat(esep), [[)]], lsep, [[]], block, [[end]])
end, function (input)
local arguments, variableArguments, block, __pass__, context
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, context = input:applyWithArgs(input.grammar.property, 'context', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (__pass__) then
return false
end
__pass__, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (__pass__) then
return false
end
__pass__, variableArguments = input:applyWithArgs(input.grammar.property, 'variableArguments', input.grammar.anything)
if not (__pass__) then
return false
end
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return __pass__, block
end)
end)) then
return false
end
return true, string.interpolate([[function ]], context:concat('.'), [[(]], (variableArguments and arguments:append('...') or arguments):concat(esep), [[)]], lsep, [[]], block, [[end]])
end)
end, arity = 0, name = 'FunctionStatement'}), [FunctionExpression] = OMeta.Rule({behavior = function (input)
local __pass__, arguments, variableArguments, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (__pass__) then
return false
end
__pass__, variableArguments = input:applyWithArgs(input.grammar.property, 'variableArguments', input.grammar.anything)
if not (__pass__) then
return false
end
__pass__, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return __pass__, block
end)
end)) then
return false
end
return true, string.interpolate([[function (]], (variableArguments and arguments:append('...') or arguments):concat(esep), [[)]], lsep, [[]], block, [[end]])
end)
end, arity = 0, name = 'FunctionExpression'}), [GetProperty] = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __pass__, context, index
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, index = input:applyWithArgs(input.grammar.property, 'index', function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.andPredicate, Name)) then
return false
end
return input:apply(input.grammar.trans)
end)
end)
if not (__pass__) then
return false
end
__pass__, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
return __pass__, context
end)
end)) then
return false
end
return true, string.interpolate([[]], context, [[.]], index, [[]])
end, function (input)
local __pass__, context, index
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, index = input:applyWithArgs(input.grammar.property, 'index', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
return __pass__, context
end)
end)) then
return false
end
return true, string.interpolate([[]], context, [[[]], index, [=[]]=])
end)
end, arity = 0, name = 'GetProperty'}), [BinaryOperation] = OMeta.Rule({behavior = function (input)
local argument, __pass__, name, context
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
if not (__pass__) then
return false
end
return input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, argument = input:apply(input.grammar.trans)
return __pass__, argument
end)
end)
end)
end)) then
return false
end
return true, string.interpolate([[]], context, [[ ]], name, [[ ]], argument, [[]])
end)
end, arity = 0, name = 'BinaryOperation'}), [UnaryOperation] = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local context, __pass__
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.property, 'name', function (input)
return input:applyWithArgs(input.grammar.object, 'not', nil)
end)) then
return false
end
__pass__, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
return __pass__, context
end)
end)) then
return false
end
return true, string.interpolate([[not ]], context, [[]])
end, function (input)
local __pass__, name, context
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
return __pass__, context
end)
end)) then
return false
end
return true, string.interpolate([[]], name, [[]], context, [[]])
end)
end, arity = 0, name = 'UnaryOperation'}), [Call] = OMeta.Rule({behavior = function (input)
local __pass__, arguments, context
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return __pass__, arguments
end)
end)) then
return false
end
return true, string.interpolate([[]], context, [[(]], arguments:concat(esep), [[)]])
end)
end, arity = 0, name = 'Call'}), [Send] = OMeta.Rule({behavior = function (input)
local arguments, __pass__, name, context
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return __pass__, arguments
end)
end)) then
return false
end
return true, string.interpolate([[]], context, [[:]], name, [[(]], arguments:concat(esep), [[)]])
end)
end, arity = 0, name = 'Send'}), [TableConstructor] = OMeta.Rule({behavior = function (input)
local properties, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, properties = input:applyWithArgs(input.grammar.property, 'properties', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return __pass__, properties
end)
end)) then
return false
end
return true, string.interpolate([[{]], properties:concat(esep), [[}]])
end)
end, arity = 0, name = 'TableConstructor'}), [SetProperty] = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __pass__, expression, index
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, index = input:applyWithArgs(input.grammar.property, 'index', function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.andPredicate, Name)) then
return false
end
return input:apply(input.grammar.trans)
end)
end)
if not (__pass__) then
return false
end
__pass__, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
return __pass__, expression
end)
end)) then
return false
end
return true, string.interpolate([[]], index, [[ = ]], expression, [[]])
end, function (input)
local expression, __pass__
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.property, 'index', input.grammar.eos)) then
return false
end
__pass__, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
return __pass__, expression
end)
end)) then
return false
end
return true, string.interpolate([[]], expression, [[]])
end, function (input)
local __pass__, expression, index
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, index = input:applyWithArgs(input.grammar.property, 'index', input.grammar.trans)
if not (__pass__) then
return false
end
__pass__, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
return __pass__, expression
end)
end)) then
return false
end
return true, string.interpolate([[[]], index, [[] = ]], expression, [[]])
end)
end, arity = 0, name = 'SetProperty'}), [Return] = OMeta.Rule({behavior = function (input)
local expressions, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, expressions = input:applyWithArgs(input.grammar.property, 'expressions', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return __pass__, expressions
end)
end)) then
return false
end
return true, string.interpolate([[return ]], expressions:concat(esep), [[]])
end)
end, arity = 0, name = 'Return'}), [Break] = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(input.grammar.anything)) then
return false
end
return true, string.interpolate([[break]])
end)
end, arity = 0, name = 'Break'}), [VariableArguments] = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(input.grammar.anything)) then
return false
end
return true, string.interpolate([[...]])
end)
end, arity = 0, name = 'VariableArguments'})})
LuaAstToSourceTranslator:merge(Commons)
return LuaAstToSourceTranslator
