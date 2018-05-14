local OMeta = require('ometa')
local Types = require('types')
local class = Types.class
local Any, Array = Types.Any, Types.Array
local Commons = require('binary_commons')
local Aux = require('auxiliary')
local utils = require('utils')
local bit = require('bit')
local bnot, band, bor, bxor, lshift, rshift = bit.bnot, bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift
local Gif = class({name = 'Gif', super = {Any}})
local Block = class({name = 'Block', super = {Any}})
local Color = class({name = 'Color', super = {Any}})
local GifGrammar = OMeta.Grammar({_grammarName = 'GifGrammar', image = OMeta.Rule({behavior = function (input)
local width, version, __pass__, ar, fields, bci, data, par, height, gct
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, 71)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 73)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 70)) then
return false
end
__pass__, version = input:applyWithArgs(input.grammar.char, 3)
if not (__pass__) then
return false
end
if not (version == '87a' or version == '89a') then
return false
end
__pass__, width = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, height = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, fields = input:applyWithArgs(input.grammar.bitfield, input.grammar.byte, {1, 3, 1, 3})
if not (__pass__) then
return false
end
__pass__, bci = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, par = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, ar = true, par == 0 and 1 or (par + 15) / 64
if not (__pass__) then
return false
end
__pass__, gct = input:applyWithArgs(input.grammar.loop, input.grammar.rgbColor, fields[1] * lshift(1, fields[4] + 1))
if not (__pass__) then
return false
end
__pass__, data = input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local label, __pass__
if not (input:applyWithArgs(input.grammar.exactly, 33)) then
return false
end
__pass__, label = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
return input:applyWithArgs(Aux.apply, label, input.grammar.genericExt)
end, function (input)
if not (input:applyWithArgs(input.grammar.exactly, 44)) then
return false
end
return input:apply(input.grammar.imageData)
end)
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 59)) then
return false
end
return true, Gif({version = version, width = width, height = height, colorResolution = fields[2], colorSort = (fields[3] == 1), backgroundColorIndex = bci, pixelAspectRatio = par, aspectRatio = ar, globalColorTable = gct, data = data})
end)
end, arity = 0, grammar = GifGrammar, name = 'image'}), dataBlock = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:applyWithArgs(input.grammar.loop, input.grammar.byte, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __result__, __pass__
__pass__, __result__ = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
if not ((__result__) ~= 0) then
return false
end
return (__result__) ~= 0, __result__
end)
end)
if not (__pass__) then
return false
end
return __pass__, __result__
end)
end, arity = 0, grammar = GifGrammar, name = 'dataBlock'}), rgbColor = OMeta.Rule({behavior = function (input)
local r, __pass__, b, g
return input:applyWithArgs(input.grammar.choice, function (input)
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
return true, Color({red = r, green = g, blue = b})
end)
end, arity = 0, grammar = GifGrammar, name = 'rgbColor'}), imageData = OMeta.Rule({behavior = function (input)
local width, top, lct, __pass__, left, fields, blocks, lzwmcs, height
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, left = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, top = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, width = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, height = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, fields = input:applyWithArgs(input.grammar.bitfield, input.grammar.byte, {1, 1, 1, 2, 3})
if not (__pass__) then
return false
end
__pass__, lct = input:applyWithArgs(input.grammar.loop, input.grammar.rgbColor, fields[1] * lshift(1, fields[5] + 1))
if not (__pass__) then
return false
end
__pass__, lzwmcs = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, blocks = input:applyWithArgs(input.grammar.many, input.grammar.dataBlock)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 0)) then
return false
end
return true, Block({name = 'Table-Based Image', left = left, top = top, width = width, height = height, interlace = (fields[2] == 1), colorSort = (fields[3] == 1), localColorTable = lct, lzwMinimumCodeSize = lzwmcs, blocks = blocks})
end)
end, arity = 0, grammar = GifGrammar, name = 'imageData'}), [249] = OMeta.Rule({behavior = function (input)
local transpIdx, __pass__, fields, delay
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, 4)) then
return false
end
__pass__, fields = input:applyWithArgs(input.grammar.bitfield, input.grammar.byte, {3, 3, 1, 1})
if not (__pass__) then
return false
end
__pass__, delay = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, transpIdx = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 0)) then
return false
end
return true, Block({name = 'Graphic Control Extension', disposalMethod = fields[2], userInput = (fields[3] == 1), transparency = (fields[4] == 1), transpIndex = transpIdx, delayTime = delay})
end)
end, arity = 0, grammar = GifGrammar, name = '249'}), [254] = OMeta.Rule({behavior = function (input)
local data, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, data = input:applyWithArgs(input.grammar.many, input.grammar.dataBlock)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 0)) then
return false
end
return true, Block({name = 'Comment Extension', data = data})
end)
end, arity = 0, grammar = GifGrammar, name = '254'}), [1] = OMeta.Rule({behavior = function (input)
local foreColorIdx, cellHeight, top, __pass__, backColorIdx, gridHeight, left, ptData, gridWidth, cellWidth
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, 12)) then
return false
end
__pass__, left = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, top = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, gridWidth = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, gridHeight = input:apply(input.grammar.int16)
if not (__pass__) then
return false
end
__pass__, cellWidth = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, cellHeight = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, foreColorIdx = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, backColorIdx = input:apply(input.grammar.byte)
if not (__pass__) then
return false
end
__pass__, ptData = input:applyWithArgs(input.grammar.many, input.grammar.dataBlock)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 0)) then
return false
end
return true, Block({name = 'Plain Text Extension', left = left, top = top, gridWidth = gridWidth, gridHeight = gridHeight, cellWidth = cellWidth, cellHeight = cellHeight, foregroundColorIndex = foreColorIdx, backgroundColorIndex = backColorIdx, plainTextData = ptData})
end)
end, arity = 0, grammar = GifGrammar, name = '1'}), [255] = OMeta.Rule({behavior = function (input)
local appAuthCode, __pass__, appId, appData
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, 11)) then
return false
end
__pass__, appId = input:applyWithArgs(input.grammar.char, 8)
if not (__pass__) then
return false
end
__pass__, appAuthCode = input:applyWithArgs(input.grammar.loop, input.grammar.byte, 3)
if not (__pass__) then
return false
end
__pass__, appData = input:applyWithArgs(input.grammar.many, input.grammar.dataBlock)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 0)) then
return false
end
return true, Block({name = 'Application Extension', applicationId = appId, applicationAuthenticationCode = appAuthCode, applicationData = appData})
end)
end, arity = 0, grammar = GifGrammar, name = '255'}), genericExt = OMeta.Rule({behavior = function (input)
local data, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, data = input:applyWithArgs(input.grammar.many, input.grammar.dataBlock)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, 0)) then
return false
end
return true, Block({name = 'Generic Extension', data = data})
end)
end, arity = 0, grammar = GifGrammar, name = 'genericExt'})})
GifGrammar:merge(Commons)
GifGrammar:merge(Commons.LittleEndian)
GifGrammar:merge(Commons.Msb0)
return GifGrammar
