local Types = require('types')
local class = Types.class
local Any, Array = Types.Any, Types.Array
local OMeta = require('ometa')
local Commons = require('binary_commons')
local Aux = require('auxiliary')
local utils = require('utils')
local Png = class({name = 'Png', super = {Any}})
local Chunk = class({name = 'Chunk', super = {Any}})
local PngGrammar = OMeta.Grammar({_grammarName = 'PngGrammar', image = OMeta.Rule({behavior = function (input)
local _success, bytes, chunks
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, 137)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 80)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 78)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 71)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 13)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 10)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 26)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 10)) then
return false
end
_success, chunks = input:applyWithArgs(input.grammar.many, input.grammar.chunk, 1)
if not (_success) then
return false
end
_success, bytes = input:applyWithArgs(input.grammar.many, input.grammar.byte)
if not (_success) then
return false
end
return true, Png({chunks = chunks, rest = bytes})
end)
end, arity = 0, grammar = nil, name = 'image'}), chunk = OMeta.Rule({behavior = function (input)
local _success, type, data, len, crc
return input:applyWithArgs(input.grammar.choice, function (input)
_success, len = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, type = input:applyWithArgs(input.grammar.varchar, 4)
if not (_success) then
return false
end
print(type, len)
_success, data = input:applyWithArgs(Aux.apply, type, input.grammar.generic, len)
if not (_success) then
return false
end
data.length = len
data.type = type
_success, crc = input:applyWithArgs(input.grammar.loop, input.grammar.byte, 4)
if not (_success) then
return false
end
return true, Chunk(data)
end)
end, arity = 0, grammar = nil, name = 'chunk'}), generic = OMeta.Rule({behavior = function (input)
local _success, d
return input:applyWithArgs(input.grammar.choice, function (input)
_success, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (_success) then
return false
end
return true, {name = "Generic chunk", data = d}
end)
end, arity = 0, grammar = nil, name = 'generic'}), IHDR = OMeta.Rule({behavior = function (input, len)
local _success, filter, interlace, w, dep, h, ctype, comp
return input:applyWithArgs(input.grammar.choice, function (input)
_success, w = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, h = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, dep = input:apply(input.grammar.byte)
if not (_success) then
return false
end
_success, ctype = input:apply(input.grammar.byte)
if not (_success) then
return false
end
_success, comp = input:apply(input.grammar.byte)
if not (_success) then
return false
end
_success, filter = input:apply(input.grammar.byte)
if not (_success) then
return false
end
_success, interlace = input:apply(input.grammar.byte)
if not (_success) then
return false
end
return true, {name = "Image header", data = {width = w, height = h, bitdepth = dep, colortype = ctype, compression = comp, filter = filter, interlace = interlace}}
end)
end, arity = 1, grammar = nil, name = 'IHDR'}), PLTE = OMeta.Rule({behavior = function (input, len)
local _success, palette
return input:applyWithArgs(input.grammar.choice, function (input)
_success, palette = input:applyWithArgs(input.grammar.loop, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _success, r, b, g
_success, r = input:apply(input.grammar.byte)
if not (_success) then
return false
end
_success, g = input:apply(input.grammar.byte)
if not (_success) then
return false
end
_success, b = input:apply(input.grammar.byte)
if not (_success) then
return false
end
return true, {red = r, green = g, blue = b}
end)
end, len / 3)
if not (_success) then
return false
end
return true, {name = "Palette", palette = palette}
end)
end, arity = 1, grammar = nil, name = 'PLTE'}), IDAT = OMeta.Rule({behavior = function (input)
local _success, d
return input:applyWithArgs(input.grammar.choice, function (input)
_success, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (_success) then
return false
end
return true, {name = "Image data"}
end)
end, arity = 0, grammar = nil, name = 'IDAT'}), IEND = OMeta.Rule({behavior = function (input)
local _success, d
return input:applyWithArgs(input.grammar.choice, function (input)
_success, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (_success) then
return false
end
return true, {name = "Image trailer"}
end)
end, arity = 0, grammar = nil, name = 'IEND'}), bKGD = OMeta.Rule({behavior = function (input)
local _success, d
return input:applyWithArgs(input.grammar.choice, function (input)
_success, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (_success) then
return false
end
return true, {name = "Background color", data = d}
end)
end, arity = 0, grammar = nil, name = 'bKGD'}), cHRM = OMeta.Rule({behavior = function (input, len)
local _success, wy, rx, wx, by, bx, ry, gy, gx
return input:applyWithArgs(input.grammar.choice, function (input)
_success, wx = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, wy = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, rx = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, ry = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, gx = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, gy = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, bx = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, by = input:apply(input.grammar.int32)
if not (_success) then
return false
end
return true, {name = "Primary chromaticities and white point", ['white x'] = wx, ['white y'] = wy, ['red x'] = rx, ['red y'] = ry, ['green x'] = gx, ['green y'] = gy, ['blue x'] = bx, ['blue y'] = by}
end)
end, arity = 1, grammar = nil, name = 'cHRM'}), gAMA = OMeta.Rule({behavior = function (input, len)
local _success, g
return input:applyWithArgs(input.grammar.choice, function (input)
_success, g = input:apply(input.grammar.int32)
if not (_success) then
return false
end
return true, {name = "Image gamma", value = g}
end)
end, arity = 1, grammar = nil, name = 'gAMA'}), hIST = OMeta.Rule({behavior = function (input, len)
local _success, d
return input:applyWithArgs(input.grammar.choice, function (input)
_success, d = input:applyWithArgs(input.grammar.loop, input.grammar.int16, len / 2)
if not (_success) then
return false
end
return true, {name = "Image histogram", data = d}
end)
end, arity = 1, grammar = nil, name = 'hIST'}), pHYs = OMeta.Rule({behavior = function (input, len)
local _success, y, x, unit
return input:applyWithArgs(input.grammar.choice, function (input)
_success, x = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, y = input:apply(input.grammar.int32)
if not (_success) then
return false
end
_success, unit = input:apply(input.grammar.byte)
if not (_success) then
return false
end
return true, {name = "Physical pixel dimensions", x = x, y = y, unit = init == 1 and 'meter' or 'unknown'}
end)
end, arity = 1, grammar = nil, name = 'pHYs'}), sBIT = OMeta.Rule({behavior = function (input)
local _success, d
return input:applyWithArgs(input.grammar.choice, function (input)
_success, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (_success) then
return false
end
return true, {name = "Significant bits", data = d}
end)
end, arity = 0, grammar = nil, name = 'sBIT'}), tEXt = OMeta.Rule({behavior = function (input)
local _success, d, tpos, str
return input:applyWithArgs(input.grammar.choice, function (input)
_success, d = input:applyWithArgs(input.grammar.loop, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _success, b
_success, b = input:apply(input.grammar.byte)
if not (_success) then
return false
end
return true, string.char(b)
end)
end, input.grammar.number)
if not (_success) then
return false
end
_success, str = true, d:concat()
if not (_success) then
return false
end
_success, tpos = true, str:find('\0', 1, true)
if not (_success) then
return false
end
return true, {name = "Textual data", keyword = str:sub(1, tpos - 1), text = str:sub(tpos + 1)}
end)
end, arity = 0, grammar = nil, name = 'tEXt'}), tIME = OMeta.Rule({behavior = function (input, len)
local _success, day, minute, second, year, month, hour
return input:applyWithArgs(input.grammar.choice, function (input)
_success, year = input:apply(input.grammar.int16)
if not (_success) then
return false
end
_success, month = input:apply(input.grammar.byte)
if not (_success) then
return false
end
_success, day = input:apply(input.grammar.byte)
if not (_success) then
return false
end
_success, hour = input:apply(input.grammar.byte)
if not (_success) then
return false
end
_success, minute = input:apply(input.grammar.byte)
if not (_success) then
return false
end
_success, second = input:apply(input.grammar.byte)
if not (_success) then
return false
end
return true, {name = "Image last-modification time", year = year, month = month, day = day, hour = hour, minute = minute, second = second}
end)
end, arity = 1, grammar = nil, name = 'tIME'}), tRNS = OMeta.Rule({behavior = function (input)
local _success, d
return input:applyWithArgs(input.grammar.choice, function (input)
_success, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (_success) then
return false
end
return true, {name = "Transparency", data = d}
end)
end, arity = 0, grammar = nil, name = 'tRNS'}), zTXt = OMeta.Rule({behavior = function (input)
local _success, d
return input:applyWithArgs(input.grammar.choice, function (input)
_success, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (_success) then
return false
end
return true, {name = "Compressed textual data", data = d}
end)
end, arity = 0, grammar = nil, name = 'zTXt'})})
PngGrammar:merge(Commons)
return PngGrammar
