local OMeta = require('ometa')
local Types = require('types')
local class = Types.class
local Any, Array = Types.Any, Types.Array
local Commons = require('binary_commons')
local Aux = require('auxiliary')
local utils = require('utils')
local Png = class({name = 'Png', super = {Any}})
local Chunk = class({name = 'Chunk', super = {Any}})
local PngGrammar = OMeta.Grammar({_grammarName = 'PngGrammar', image = OMeta.Rule({behavior = function (input)
local __pass__, rest, chunks
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
__pass__, chunks = input:applyWithArgs(input.grammar.many, input.grammar.chunk, 1)
if not (__pass__) then
return false
end
__pass__, rest = input:applyWithArgs(input.grammar.many, input.grammar.byte)
if not (__pass__) then
return false
end
return true, Png({chunks = chunks, rest = rest})
end)
end, arity = 0, grammar = PngGrammar, name = 'image'}), chunk = OMeta.Rule({behavior = function (input)
local data, type, __pass__, len, crc
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, len = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, type = input:applyWithArgs(input.grammar.char, 4)
if not (__pass__) then
return false
end
print(type, len)
__pass__, data = input:applyWithArgs(Aux.apply, type, input.grammar.generic, len)
if not (__pass__) then
return false
end
data.length = len
data.type = type
__pass__, crc = input:applyWithArgs(input.grammar.loop, input.grammar.byte, 4)
if not (__pass__) then
return false
end
return true, Chunk(data)
end)
end, arity = 0, grammar = PngGrammar, name = 'chunk'}), generic = OMeta.Rule({behavior = function (input)
local d, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (__pass__) then
return false
end
return true, {name = "Generic chunk", data = d}
end)
end, arity = 0, grammar = PngGrammar, name = 'generic'}), IHDR = OMeta.Rule({behavior = function (input, len)
local il, fltr, __pass__, w, ctype, h, dep, comp
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, w = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, h = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, dep = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, ctype = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, comp = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, fltr = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, il = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
return true, {name = "Image header", data = {width = w, height = h, bitdepth = dep, colortype = ctype, compression = comp, filter = fltr, interlace = il}}
end)
end, arity = 1, grammar = PngGrammar, name = 'IHDR'}), PLTE = OMeta.Rule({behavior = function (input, len)
local palette, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, palette = input:applyWithArgs(input.grammar.loop, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local r, __pass__, b, g
__pass__, r = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, g = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, b = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
return true, {red = r, green = g, blue = b}
end)
end, len / 3)
if not (__pass__) then
return false
end
return true, {name = "Palette", palette = palette}
end)
end, arity = 1, grammar = PngGrammar, name = 'PLTE'}), IDAT = OMeta.Rule({behavior = function (input)
local d, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (__pass__) then
return false
end
return true, {name = "Image data"}
end)
end, arity = 0, grammar = PngGrammar, name = 'IDAT'}), IEND = OMeta.Rule({behavior = function (input)
local d, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (__pass__) then
return false
end
return true, {name = "Image trailer"}
end)
end, arity = 0, grammar = PngGrammar, name = 'IEND'}), bKGD = OMeta.Rule({behavior = function (input)
local d, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (__pass__) then
return false
end
return true, {name = "Background color", data = d}
end)
end, arity = 0, grammar = PngGrammar, name = 'bKGD'}), cHRM = OMeta.Rule({behavior = function (input, len)
local wy, __pass__, rx, wx, by, gx, ry, gy, bx
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, wx = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, wy = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, rx = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, ry = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, gx = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, gy = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, bx = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, by = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
return true, {name = "Primary chromaticities and white point", ['white x'] = wx, ['white y'] = wy, ['red x'] = rx, ['red y'] = ry, ['green x'] = gx, ['green y'] = gy, ['blue x'] = bx, ['blue y'] = by}
end)
end, arity = 1, grammar = PngGrammar, name = 'cHRM'}), gAMA = OMeta.Rule({behavior = function (input, len)
local g, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, g = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
return true, {name = "Image gamma", value = g}
end)
end, arity = 1, grammar = PngGrammar, name = 'gAMA'}), hIST = OMeta.Rule({behavior = function (input, len)
local d, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, d = input:applyWithArgs(input.grammar.loop, input.grammar.int16, len / 2)
if not (__pass__) then
return false
end
return true, {name = "Image histogram", data = d}
end)
end, arity = 1, grammar = PngGrammar, name = 'hIST'}), pHYs = OMeta.Rule({behavior = function (input, len)
local y, x, unit, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, x = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, y = input:apply(input.grammar.int32)
if not (__pass__) then
return false
end
__pass__, unit = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
return true, {name = "Physical pixel dimensions", x = x, y = y, unit = init == 1 and 'meter' or 'unknown'}
end)
end, arity = 1, grammar = PngGrammar, name = 'pHYs'}), sBIT = OMeta.Rule({behavior = function (input)
local d, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (__pass__) then
return false
end
return true, {name = "Significant bits", data = d}
end)
end, arity = 0, grammar = PngGrammar, name = 'sBIT'}), tEXt = OMeta.Rule({behavior = function (input)
local tpos, __pass__, str
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, str = input:applyWithArgs(input.grammar.codesToString, function (input)
return input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
end)
if not (__pass__) then
return false
end
__pass__, tpos = true, str:find('\0', 1, true)
if not (__pass__) then
return false
end
return true, {name = "Textual data", keyword = str:sub(1, tpos - 1), text = str:sub(tpos + 1)}
end)
end, arity = 0, grammar = PngGrammar, name = 'tEXt'}), tIME = OMeta.Rule({behavior = function (input, len)
local day, minute, second, hour, year, month, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, year = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, month = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, day = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, hour = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, minute = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, second = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
return true, {name = "Image last-modification time", year = year, month = month, day = day, hour = hour, minute = minute, second = second}
end)
end, arity = 1, grammar = PngGrammar, name = 'tIME'}), tRNS = OMeta.Rule({behavior = function (input)
local d, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (__pass__) then
return false
end
return true, {name = "Transparency", data = d}
end)
end, arity = 0, grammar = PngGrammar, name = 'tRNS'}), zTXt = OMeta.Rule({behavior = function (input)
local d, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, d = input:applyWithArgs(input.grammar.loop, input.grammar.byte, input.grammar.number)
if not (__pass__) then
return false
end
return true, {name = "Compressed textual data", data = d}
end)
end, arity = 0, grammar = PngGrammar, name = 'zTXt'})})
PngGrammar:merge(Commons)
PngGrammar:merge(Commons.BigEndian)
return PngGrammar
