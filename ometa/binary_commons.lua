local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local bit = require('bit')
local bnot, band, bor, bxor, lshift, rshift = bit.bnot, bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift
local Types = require('types')
local Any, Array = Types.Any, Types.Array
local OMeta = require('ometa')
local utils = require('utils')
local Commons = require('commons')
local BinaryCommons = OMeta.Grammar({_grammarName = 'BinaryCommons', byte = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == "number" and band(input.stream._head, 255) == input.stream._head) then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, name = 'byte'}), char = OMeta.Rule({behavior = function (input, n)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.codesToString, function (input)
return input:applyWithArgs(input.grammar.loop, input.grammar.byte, n or 1)
end)
end)
end, arity = 1, name = 'char'})})
BinaryCommons:merge(Commons)
local function bitfield(msb, number, bitn)
local fields = {}
local f, t, s
if msb then
f, t, s = #bitn, 1, -1
else
f, t, s = 1, #bitn, 1
end
for fn = f, t, s do
local n = bitn[fn]
local mask = bnot(lshift(bnot(0), n))
local field = band(number, mask)
fields[fn] = field
number = rshift(number, n)
end
return fields
end
local Msb0 = OMeta.Grammar({_grammarName = 'Msb0', bit = OMeta.Rule({behavior = function (input, offset, n)
local val, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, val = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
return true, rshift(band(rshift(255, offset or 0), val), 8 - (n or 1) - (offset or 0))
end)
end, arity = 2, name = 'bit'}), bitfield = OMeta.Rule({behavior = function (input, r, bitn)
local val, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, val = input:apply(r)
if not (__pass__) then
return false
end
return true, bitfield(true, val, bitn)
end)
end, arity = 2, name = 'bitfield'})})
local Lsb0 = OMeta.Grammar({_grammarName = 'Lsb0', bit = OMeta.Rule({behavior = function (input, offset, n)
local val, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, val = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
return true, band(rshift(val, offset or 0), bnot(lshift(bnot(0), n or 1)))
end)
end, arity = 2, name = 'bit'}), bitfield = OMeta.Rule({behavior = function (input, r, bitn)
local val, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, val = input:apply(r)
if not (__pass__) then
return false
end
return true, bitfield(false, val, bitn)
end)
end, arity = 2, name = 'bitfield'})})
local BigEndian = OMeta.Grammar({_grammarName = 'BigEndian', int16 = OMeta.Rule({behavior = function (input)
local b, __pass__, a
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, a = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, b = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
return true, bor(lshift(a, 8), b)
end)
end, arity = 0, name = 'int16'}), int32 = OMeta.Rule({behavior = function (input)
local b, __pass__, a
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, a = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, b = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
return true, bor(lshift(a, 16), b)
end)
end, arity = 0, name = 'int32'})})
local LittleEndian = OMeta.Grammar({_grammarName = 'LittleEndian', int16 = OMeta.Rule({behavior = function (input)
local b, __pass__, a
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, b = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, a = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
return true, bor(lshift(a, 8), b)
end)
end, arity = 0, name = 'int16'}), int32 = OMeta.Rule({behavior = function (input)
local b, __pass__, a
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, b = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, a = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
return true, bor(lshift(a, 16), b)
end)
end, arity = 0, name = 'int32'})})
BinaryCommons.Msb0 = Msb0
BinaryCommons.Lsb0 = Lsb0
BinaryCommons.BigEndian = BigEndian
BinaryCommons.LittleEndian = LittleEndian
return BinaryCommons
