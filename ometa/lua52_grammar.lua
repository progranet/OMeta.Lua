local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local Types = require('types')
local Any, Array = Types.Any, Types.Array
local OMeta = require('ometa')
local utils = require('utils')
local asc = require('abstractsyntax_commons')
local Literal, NilLiteral, BooleanLiteral, NumberLiteral, IntegerLiteral, RealLiteral, StringLiteral, Name, Keyword, Special, Node, Statement, Expression, Control, Iterative, Invocation = asc.Literal, asc.NilLiteral, asc.BooleanLiteral, asc.NumberLiteral, asc.IntegerLiteral, asc.RealLiteral, asc.StringLiteral, asc.Name, asc.Keyword, asc.Special, asc.Node, asc.Statement, asc.Expression, asc.Control, asc.Iterative, asc.Invocation
local las = require('lua_abstractsyntax')
local Get, Set, Group, Block, Chunk, Do, While, Repeat, If, ElseIf, For, ForIn, Function, MethodStatement, FunctionStatement, FunctionExpression, Return, Break, LastStatement, Call, Send, BinaryOperation, UnaryOperation, GetProperty, VariableArguments, TableConstructor, SetProperty, Goto, Label = las.Get, las.Set, las.Group, las.Block, las.Chunk, las.Do, las.While, las.Repeat, las.If, las.ElseIf, las.For, las.ForIn, las.Function, las.MethodStatement, las.FunctionStatement, las.FunctionExpression, las.Return, las.Break, las.LastStatement, las.Call, las.Send, las.BinaryOperation, las.UnaryOperation, las.GetProperty, las.VariableArguments, las.TableConstructor, las.SetProperty, las.lua52.Goto, las.lua52.Label
local LuaGrammar = require('lua_grammar')
local Lua52Grammar = OMeta.Grammar({_grammarName = 'Lua52Grammar', special = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[::]])
end, LuaGrammar.special)
end, arity = 0, grammar = nil, name = 'special'}), keyword = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, LuaGrammar.keyword, function (input)
return input:applyWithArgs(input.grammar.exactly, 'goto')
end)
end, arity = 0, grammar = nil, name = 'keyword'}), stat = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, LuaGrammar.stat, function (input)
local _pass, labelName
if not (input:applyWithArgs(input.grammar.token, "goto")) then
return false
end
_pass, labelName = input:apply(input.grammar.name)
if not (_pass) then
return false
end
return true, Goto({name = labelName})
end, input.grammar.label)
end, arity = 0, grammar = nil, name = 'stat'}), label = OMeta.Rule({behavior = function (input)
local _pass, labelName
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "::")) then
return false
end
_pass, labelName = input:apply(input.grammar.name)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "::")) then
return false
end
return true, Label({name = labelName})
end)
end, arity = 0, grammar = nil, name = 'label'})})
Lua52Grammar:merge(LuaGrammar)
return Lua52Grammar
