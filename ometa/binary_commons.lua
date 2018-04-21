local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local bit = require('bit')
local band, bor, lshift = bit.band, bit.bor, bit.lshift
local Types = require('types')
local Any, Array = Types.Any, Types.Array
local OMeta = require('ometa')
local utils = require('utils')
local Commons = require('commons')
local BinaryCommons = OMeta.Grammar({_grammarName = 'BinaryCommons', byte = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == "number" and band(input.stream._head, 255) == input.stream._head) then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, grammar = nil, name = 'byte'}), int16 = OMeta.Rule({behavior = function (input)
local _pass, a, b
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, a = input:apply(input.grammar.byte)
if not (_pass) then
return false
end
_pass, b = input:apply(input.grammar.byte)
if not (_pass) then
return false
end
return true, bor(lshift(a, 8), b)
end)
end, arity = 0, grammar = nil, name = 'int16'}), int32 = OMeta.Rule({behavior = function (input)
local _pass, a, b
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, a = input:apply(input.grammar.int16)
if not (_pass) then
return false
end
_pass, b = input:apply(input.grammar.int16)
if not (_pass) then
return false
end
return true, bor(lshift(a, 16), b)
end)
end, arity = 0, grammar = nil, name = 'int32'}), varchar = OMeta.Rule({behavior = function (input)
local _pass, str
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, str = input:applyWithArgs(input.grammar.loop, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, b
_pass, b = input:apply(input.grammar.byte)
if not (_pass) then
return false
end
return true, string.char(b)
end)
end, input.grammar.number)
if not (_pass) then
return false
end
return true, str:concat()
end)
end, arity = 0, grammar = nil, name = 'varchar'})})
BinaryCommons:merge(Commons)
return BinaryCommons
