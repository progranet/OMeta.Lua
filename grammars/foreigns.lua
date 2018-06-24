local OMeta = require('ometa')
local Commons = require('commons')
local Foreign, Interrupter
local Main = OMeta.Grammar({_grammarName = 'Main', dispatch = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(Foreign.apply)) then
return false
end
if not (input:applyForeign(Foreign, Foreign.apply)) then
return false
end
if not (input:applyForeign(Foreign, Foreign.apply)) then
return false
end
return input:applyForeign(Interrupter, Foreign.apply)
end)
end, arity = 0, name = 'dispatch'}), target = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
print('hello from Main')
return input:apply(input.grammar.anything)
end)
end, arity = 0, name = 'target'})})
Main:merge(Commons)
Foreign = OMeta.Grammar({_grammarName = 'Foreign', apply = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.target)
end)
end, arity = 0, name = 'apply'}), target = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
print('hello from Foreign')
return input:apply(input.grammar.anything)
end)
end, arity = 0, name = 'target'})})
Foreign:merge(Commons)
Interrupter = OMeta.Grammar({_grammarName = 'Interrupter', target = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
print('hello from Interrupter')
return input:apply(input.grammar.anything)
end)
end, arity = 0, name = 'target'})})
Interrupter:merge(Commons)
Main.dispatch:matchString('abcd')
return Main
