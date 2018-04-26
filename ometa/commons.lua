local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local Types = require('types')
local Any, Array = Types.Any, Types.Array
local OMeta = require('ometa')
local utils = require('utils')
local StdLib = require('ometa_stdlib')
local Commons = OMeta.Grammar({_grammarName = 'Commons', eos = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.notPredicate, input.grammar.anything)
end)
end, arity = 0, grammar = nil, name = 'eos'}), empty = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
return true
end)
end, arity = 0, grammar = nil, name = 'empty'}), string = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'string') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = nil, name = 'string'}), char = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'string' and #input.stream._head == 1) then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = nil, name = 'char'}), number = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'number') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = nil, name = 'number'}), boolean = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'boolean') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = nil, name = 'boolean'}), table = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'table') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = nil, name = 'table'}), ['function'] = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'function') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = nil, name = 'function'}), notLast = OMeta.Rule({behavior = function (input, element)
local _pass, prev
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, prev = input:apply(element)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.andPredicate, element)) then
return false
end
return true, prev
end)
end, arity = 1, grammar = nil, name = 'notLast'}), list = OMeta.Rule({behavior = function (input, element, delim, minimum)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, rest, first
_pass, first = input:apply(element)
if not (_pass) then
return false
end
_pass, rest = input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:apply(delim)) then
return false
end
return input:apply(element)
end)
end)
if not (_pass) then
return false
end
if not ((#rest + 1) >= (minimum or 0)) then
return false
end
return true, rest:prepend(first)
end, function (input)
local _pass
if not (not minimum or minimum == 0) then
return false
end
return true, Array({})
end)
end, arity = 3, grammar = nil, name = 'list'}), range = OMeta.Rule({behavior = function (input, first, last)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(first)) then
return false
end
if not (input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.notPredicate, last)) then
return false
end
return input:apply(input.grammar.anything)
end)
end)) then
return false
end
return input:apply(last)
end)
end)
end)
end, arity = 2, grammar = nil, name = 'range'})})
Commons:merge(StdLib)
return Commons
