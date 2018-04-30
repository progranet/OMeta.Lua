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
local _pass, node
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, node = input:applyWithArgs(input.grammar.andPredicate, input.grammar.anything)
if not (_pass) then
return false
end
return input:applyWithArgs(Aux.apply, getType(node), input.grammar.unexpected)
end)
end, arity = 0, grammar = nil, name = 'trans'}), unexpected = OMeta.Rule({behavior = function (input)
local _pass, node
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, node = input:apply(input.grammar.anything)
if not (_pass) then
return false
end
return error('unexpected node: ' .. tostring(node))
end)
end, arity = 0, grammar = nil, name = 'unexpected'}), [NilLiteral] = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(input.grammar.anything)) then
return false
end
return true, 'nil'
end)
end, arity = 0, grammar = nil, name = 'NilLiteral'}), [BooleanLiteral] = OMeta.Rule({behavior = function (input)
local _pass, value
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
_pass, value = input:apply(input.grammar.anything)
return _pass, value
end, nil)) then
return false
end
return true, string.interpolate([[]], value, [[]])
end)
end, arity = 0, grammar = nil, name = 'BooleanLiteral'}), [RealLiteral] = OMeta.Rule({behavior = function (input)
local _pass, value
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
_pass, value = input:apply(input.grammar.anything)
return _pass, value
end, nil)) then
return false
end
return true, string.interpolate([[]], value, [[]])
end)
end, arity = 0, grammar = nil, name = 'RealLiteral'}), [IntegerLiteral] = OMeta.Rule({behavior = function (input)
local _pass, value
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
_pass, value = input:apply(input.grammar.anything)
return _pass, value
end, nil)) then
return false
end
return true, string.interpolate([[]], value, [[]])
end)
end, arity = 0, grammar = nil, name = 'IntegerLiteral'}), [Name] = OMeta.Rule({behavior = function (input)
local _pass, value
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
_pass, value = input:apply(input.grammar.anything)
return _pass, value
end, nil)) then
return false
end
return true, value
end)
end, arity = 0, grammar = nil, name = 'Name'}), [Keyword] = OMeta.Rule({behavior = function (input)
local _pass, value
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
_pass, value = input:apply(input.grammar.anything)
return _pass, value
end, nil)) then
return false
end
return true, value
end)
end, arity = 0, grammar = nil, name = 'Keyword'}), [Special] = OMeta.Rule({behavior = function (input)
local _pass, value
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
_pass, value = input:apply(input.grammar.anything)
return _pass, value
end, nil)) then
return false
end
return true, value
end)
end, arity = 0, grammar = nil, name = 'Special'}), [StringLiteral] = OMeta.Rule({behavior = function (input)
local _pass, value, rdelim, ldelim
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, function (input)
_pass, value = input:apply(input.grammar.anything)
return _pass, value
end, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, ldelim = input:applyWithArgs(input.grammar.property, 'ldelim', function (input)
return input:applyWithArgs(input.grammar.optional, input.grammar.anything)
end)
if not (_pass) then
return false
end
_pass, rdelim = input:applyWithArgs(input.grammar.property, 'rdelim', function (input)
return input:applyWithArgs(input.grammar.optional, input.grammar.anything)
end)
return _pass, rdelim
end)
end)) then
return false
end
return true, string.interpolate([[]], ldelim or "'", [[]], value, [[]], rdelim or "'", [[]])
end)
end, arity = 0, grammar = nil, name = 'StringLiteral'}), [Get] = OMeta.Rule({behavior = function (input)
local _pass, name
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
_pass, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
return _pass, name
end)) then
return false
end
return true, name
end)
end, arity = 0, grammar = nil, name = 'Get'}), [Set] = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, names, expressions
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.property, 'isLocal', true)) then
return false
end
_pass, names = input:applyWithArgs(input.grammar.property, 'names', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans, 1)
end)
if not (_pass) then
return false
end
_pass, expressions = input:applyWithArgs(input.grammar.property, 'expressions', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans, 1)
end)
return _pass, expressions
end)
end)) then
return false
end
return true, string.interpolate([[local ]], names:concat(esep), [[ = ]], expressions:concat(esep), [[]])
end, function (input)
local _pass, names
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.property, 'isLocal', true)) then
return false
end
_pass, names = input:applyWithArgs(input.grammar.property, 'names', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans, 1)
end)
return _pass, names
end)
end)) then
return false
end
return true, string.interpolate([[local ]], names:concat(esep), [[]])
end, function (input)
local _pass, names, expressions
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, names = input:applyWithArgs(input.grammar.property, 'names', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans, 1)
end)
if not (_pass) then
return false
end
_pass, expressions = input:applyWithArgs(input.grammar.property, 'expressions', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans, 1)
end)
return _pass, expressions
end)
end)) then
return false
end
return true, string.interpolate([[]], names:concat(esep), [[ = ]], expressions:concat(esep), [[]])
end)
end, arity = 0, grammar = nil, name = 'Set'}), [Chunk] = OMeta.Rule({behavior = function (input)
local _pass, statements
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
_pass, statements = input:applyWithArgs(input.grammar.property, 'statements', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return _pass, statements
end)) then
return false
end
return true, statements:append(''):concat(lsep)
end)
end, arity = 0, grammar = nil, name = 'Chunk'}), [Group] = OMeta.Rule({behavior = function (input)
local _pass, expression
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
_pass, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
return _pass, expression
end)) then
return false
end
return true, string.interpolate([[(]], expression, [[)]])
end)
end, arity = 0, grammar = nil, name = 'Group'}), [Do] = OMeta.Rule({behavior = function (input)
local _pass, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return _pass, block
end)) then
return false
end
return true, string.interpolate([[do]], lsep, [[]], block, [[end]])
end)
end, arity = 0, grammar = nil, name = 'Do'}), [While] = OMeta.Rule({behavior = function (input)
local _pass, expression, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
if not (_pass) then
return false
end
_pass, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
return _pass, expression
end)
end)) then
return false
end
return true, string.interpolate([[while ]], expression, [[ do]], lsep, [[]], block, [[end]])
end)
end, arity = 0, grammar = nil, name = 'While'}), [Repeat] = OMeta.Rule({behavior = function (input)
local _pass, expression, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
if not (_pass) then
return false
end
_pass, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
return _pass, expression
end)
end)) then
return false
end
return true, string.interpolate([[repeat]], lsep, [[]], block, [[until ]], expression, [[]])
end)
end, arity = 0, grammar = nil, name = 'Repeat'}), [If] = OMeta.Rule({behavior = function (input)
local _pass, elseBlock, elseIfs, expression, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
if not (_pass) then
return false
end
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
if not (_pass) then
return false
end
_pass, elseIfs = input:applyWithArgs(input.grammar.property, 'elseIfs', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (_pass) then
return false
end
_pass, elseBlock = input:applyWithArgs(input.grammar.property, 'elseBlock', input.grammar.trans)
return _pass, elseBlock
end)
end)) then
return false
end
return true, string.interpolate([[if ]], expression, [[ then]], lsep, [[]], block, [[]], elseIfs:concat(), [[]], (#elseBlock ~= 0 and (string.interpolate([[else]], lsep, [[]], elseBlock, [[]])) or string.interpolate([[]])), [[end]])
end)
end, arity = 0, grammar = nil, name = 'If'}), [ElseIf] = OMeta.Rule({behavior = function (input)
local _pass, block, expression
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
if not (_pass) then
return false
end
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return _pass, block
end)
end)) then
return false
end
return true, string.interpolate([[elseif ]], expression, [[ then]], lsep, [[]], block, [[]])
end)
end, arity = 0, grammar = nil, name = 'ElseIf'}), [For] = OMeta.Rule({behavior = function (input)
local _pass, block, stepExpression, startExpression, name, stopExpression
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (_pass) then
return false
end
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
if not (_pass) then
return false
end
_pass, startExpression = input:applyWithArgs(input.grammar.property, 'startExpression', input.grammar.trans)
if not (_pass) then
return false
end
_pass, stopExpression = input:applyWithArgs(input.grammar.property, 'stopExpression', input.grammar.trans)
if not (_pass) then
return false
end
_pass, stepExpression = input:applyWithArgs(input.grammar.property, 'stepExpression', input.grammar.trans)
return _pass, stepExpression
end)
end)) then
return false
end
return true, string.interpolate([[for ]], name, [[ = ]], startExpression, [[]], esep, [[]], stopExpression, [[]], (stepExpression == '1' and string.interpolate([[]]) or string.interpolate([[]], esep, [[]], stepExpression, [[]])), [[ do]], lsep, [[]], block, [[end]])
end)
end, arity = 0, grammar = nil, name = 'For'}), [ForIn] = OMeta.Rule({behavior = function (input)
local _pass, names, expressions, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, names = input:applyWithArgs(input.grammar.property, 'names', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (_pass) then
return false
end
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
if not (_pass) then
return false
end
_pass, expressions = input:applyWithArgs(input.grammar.property, 'expressions', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return _pass, expressions
end)
end)) then
return false
end
return true, string.interpolate([[for ]], names:concat(esep), [[ in ]], expressions:concat(esep), [[ do]], lsep, [[]], block, [[end]])
end)
end, arity = 0, grammar = nil, name = 'ForIn'}), [MethodStatement] = OMeta.Rule({behavior = function (input)
local _pass, arguments, variableArguments, block, name, context
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, context = input:applyWithArgs(input.grammar.property, 'context', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (_pass) then
return false
end
_pass, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (_pass) then
return false
end
_pass, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (_pass) then
return false
end
_pass, variableArguments = input:applyWithArgs(input.grammar.property, 'variableArguments', input.grammar.anything)
if not (_pass) then
return false
end
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return _pass, block
end)
end)) then
return false
end
return true, string.interpolate([[function ]], context:concat('.'), [[:]], name, [[(]], (variableArguments and arguments:append('...') or arguments):concat(esep), [[)]], lsep, [[]], block, [[end]])
end)
end, arity = 0, grammar = nil, name = 'MethodStatement'}), [FunctionStatement] = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, variableArguments, arguments, name, block
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.property, 'isLocal', true)) then
return false
end
_pass, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (_pass) then
return false
end
_pass, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (_pass) then
return false
end
_pass, variableArguments = input:applyWithArgs(input.grammar.property, 'variableArguments', input.grammar.anything)
if not (_pass) then
return false
end
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return _pass, block
end)
end)) then
return false
end
return true, string.interpolate([[local function ]], name, [[(]], (variableArguments and arguments:append('...') or arguments):concat(esep), [[)]], lsep, [[]], block, [[end]])
end, function (input)
local _pass, block, arguments, variableArguments, context
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, context = input:applyWithArgs(input.grammar.property, 'context', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (_pass) then
return false
end
_pass, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (_pass) then
return false
end
_pass, variableArguments = input:applyWithArgs(input.grammar.property, 'variableArguments', input.grammar.anything)
if not (_pass) then
return false
end
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return _pass, block
end)
end)) then
return false
end
return true, string.interpolate([[function ]], context:concat('.'), [[(]], (variableArguments and arguments:append('...') or arguments):concat(esep), [[)]], lsep, [[]], block, [[end]])
end)
end, arity = 0, grammar = nil, name = 'FunctionStatement'}), [FunctionExpression] = OMeta.Rule({behavior = function (input)
local _pass, arguments, variableArguments, block
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
if not (_pass) then
return false
end
_pass, variableArguments = input:applyWithArgs(input.grammar.property, 'variableArguments', input.grammar.anything)
if not (_pass) then
return false
end
_pass, block = input:applyWithArgs(input.grammar.property, 'block', input.grammar.trans)
return _pass, block
end)
end)) then
return false
end
return true, string.interpolate([[function (]], (variableArguments and arguments:append('...') or arguments):concat(esep), [[)]], lsep, [[]], block, [[end]])
end)
end, arity = 0, grammar = nil, name = 'FunctionExpression'}), [GetProperty] = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, context, index
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, index = input:applyWithArgs(input.grammar.property, 'index', function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.andPredicate, Name)) then
return false
end
return input:apply(input.grammar.trans)
end)
end)
if not (_pass) then
return false
end
_pass, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
return _pass, context
end)
end)) then
return false
end
return true, string.interpolate([[]], context, [[.]], index, [[]])
end, function (input)
local _pass, context, index
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, index = input:applyWithArgs(input.grammar.property, 'index', input.grammar.trans)
if not (_pass) then
return false
end
_pass, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
return _pass, context
end)
end)) then
return false
end
return true, string.interpolate([[]], context, [[[]], index, [=[]]=])
end)
end, arity = 0, grammar = nil, name = 'GetProperty'}), [BinaryOperation] = OMeta.Rule({behavior = function (input)
local _pass, argument, name, context
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (_pass) then
return false
end
_pass, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
if not (_pass) then
return false
end
return input:applyWithArgs(input.grammar.property, 'arguments', function (input)
_pass, argument = input:apply(input.grammar.trans)
return _pass, argument
end)
end)
end)) then
return false
end
return true, string.interpolate([[]], context, [[ ]], name, [[ ]], argument, [[]])
end)
end, arity = 0, grammar = nil, name = 'BinaryOperation'}), [UnaryOperation] = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, context
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.property, 'name', function (input)
return input:applyWithArgs(input.grammar.object, 'not', nil)
end)) then
return false
end
_pass, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
return _pass, context
end)
end)) then
return false
end
return true, string.interpolate([[not ]], context, [[]])
end, function (input)
local _pass, name, context
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (_pass) then
return false
end
_pass, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
return _pass, context
end)
end)) then
return false
end
return true, string.interpolate([[]], name, [[]], context, [[]])
end)
end, arity = 0, grammar = nil, name = 'UnaryOperation'}), [Call] = OMeta.Rule({behavior = function (input)
local _pass, arguments, context
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
if not (_pass) then
return false
end
_pass, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return _pass, arguments
end)
end)) then
return false
end
return true, string.interpolate([[]], context, [[(]], arguments:concat(esep), [[)]])
end)
end, arity = 0, grammar = nil, name = 'Call'}), [Send] = OMeta.Rule({behavior = function (input)
local _pass, arguments, name, context
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, name = input:applyWithArgs(input.grammar.property, 'name', input.grammar.trans)
if not (_pass) then
return false
end
_pass, context = input:applyWithArgs(input.grammar.property, 'context', input.grammar.trans)
if not (_pass) then
return false
end
_pass, arguments = input:applyWithArgs(input.grammar.property, 'arguments', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return _pass, arguments
end)
end)) then
return false
end
return true, string.interpolate([[]], context, [[:]], name, [[(]], arguments:concat(esep), [[)]])
end)
end, arity = 0, grammar = nil, name = 'Send'}), [TableConstructor] = OMeta.Rule({behavior = function (input)
local _pass, properties
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
_pass, properties = input:applyWithArgs(input.grammar.property, 'properties', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return _pass, properties
end)) then
return false
end
return true, string.interpolate([[{]], properties:concat(esep), [[}]])
end)
end, arity = 0, grammar = nil, name = 'TableConstructor'}), [SetProperty] = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, expression, index
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, index = input:applyWithArgs(input.grammar.property, 'index', function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.andPredicate, Name)) then
return false
end
return input:apply(input.grammar.trans)
end)
end)
if not (_pass) then
return false
end
_pass, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
return _pass, expression
end)
end)) then
return false
end
return true, string.interpolate([[]], index, [[ = ]], expression, [[]])
end, function (input)
local _pass, expression
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.property, 'index', input.grammar.eos)) then
return false
end
_pass, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
return _pass, expression
end)
end)) then
return false
end
return true, string.interpolate([[]], expression, [[]])
end, function (input)
local _pass, expression, index
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, index = input:applyWithArgs(input.grammar.property, 'index', input.grammar.trans)
if not (_pass) then
return false
end
_pass, expression = input:applyWithArgs(input.grammar.property, 'expression', input.grammar.trans)
return _pass, expression
end)
end)) then
return false
end
return true, string.interpolate([[[]], index, [[] = ]], expression, [[]])
end)
end, arity = 0, grammar = nil, name = 'SetProperty'}), [Return] = OMeta.Rule({behavior = function (input)
local _pass, expressions
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
_pass, expressions = input:applyWithArgs(input.grammar.property, 'expressions', function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.trans)
end)
return _pass, expressions
end)) then
return false
end
return true, string.interpolate([[return ]], expressions:concat(esep), [[]])
end)
end, arity = 0, grammar = nil, name = 'Return'}), [Break] = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(input.grammar.anything)) then
return false
end
return true, string.interpolate([[break]])
end)
end, arity = 0, grammar = nil, name = 'Break'}), [VariableArguments] = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(input.grammar.anything)) then
return false
end
return true, string.interpolate([[...]])
end)
end, arity = 0, grammar = nil, name = 'VariableArguments'})})
LuaAstToSourceTranslator:merge(Commons)
return LuaAstToSourceTranslator
