local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local Types = require('types')
local Any, Array = Types.Any, Types.Array
local OMeta = require('ometa')
local utils = require('utils')
local StdLib = require('ometa_stdlib')
local Commons = OMeta.Grammar({_grammarName = 'Commons', eos = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.notPredicate, input.grammar.anything)
end)
end, arity = 0, grammar = Commons, name = 'eos'}), empty = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return true
end)
end, arity = 0, grammar = Commons, name = 'empty'}), string = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'string') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = Commons, name = 'string'}), number = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'number') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = Commons, name = 'number'}), boolean = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'boolean') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = Commons, name = 'boolean'}), table = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'table') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = Commons, name = 'table'}), ['function'] = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'function') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = Commons, name = 'function'}), toNumber = OMeta.Rule({behavior = function (input, source)
local str, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, str = input:apply(source)
if not (__pass__) then
return false
end
return true, tonumber(str)
end)
end, arity = 1, grammar = Commons, name = 'toNumber'}), toString = OMeta.Rule({behavior = function (input, source)
local val, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, val = input:apply(source)
if not (__pass__) then
return false
end
return true, tostring(val)
end)
end, arity = 1, grammar = Commons, name = 'toString'}), codesToString = OMeta.Rule({behavior = function (input, source)
local val, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, val = input:apply(source)
if not (__pass__) then
return false
end
return input:applyWithArgs(input.grammar.choice, function (input)
if not (Array:isInstance(val)) then
return false
end
return true, string.char(unpack(val))
end, function (input)
return true, string.char(val)
end)
end)
end, arity = 1, grammar = Commons, name = 'codesToString'}), charToCode = OMeta.Rule({behavior = function (input, source)
local str, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, str = input:apply(source)
if not (__pass__) then
return false
end
return true, str:byte()
end)
end, arity = 1, grammar = Commons, name = 'charToCode'}), concat = OMeta.Rule({behavior = function (input, source, sep)
local chars, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, chars = input:apply(source)
if not (__pass__) then
return false
end
return true, chars:concat(sep)
end)
end, arity = 2, grammar = Commons, name = 'concat'}), notLast = OMeta.Rule({behavior = function (input, element)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(element)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.andPredicate, element)) then
return false
end
return true, __result__
end)
end, arity = 1, grammar = Commons, name = 'notLast'}), list = OMeta.Rule({behavior = function (input, element, delim, minimum)
return input:applyWithArgs(input.grammar.choice, function (input)
local __pass__, rest, first
__pass__, first = input:apply(element)
if not (__pass__) then
return false
end
__pass__, rest = input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(delim)) then
return false
end
return input:apply(element)
end)
end)
if not (__pass__) then
return false
end
if not ((#rest + 1) >= (minimum or 0)) then
return false
end
return true, rest:prepend(first)
end, function (input)
if not (not minimum or minimum == 0) then
return false
end
return true, Array({})
end)
end, arity = 3, grammar = Commons, name = 'list'}), range = OMeta.Rule({behavior = function (input, first, last)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(first)) then
return false
end
if not (input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
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
end, arity = 2, grammar = Commons, name = 'range'})})
Commons:merge(StdLib)
return Commons
