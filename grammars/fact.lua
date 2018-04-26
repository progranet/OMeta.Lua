local OMeta = require('ometa')
local Factorial = OMeta.Grammar({_grammarName = 'Factorial', fact = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.exactly, 0)) then
return false
end
return true, 1
end, function (input)
local _pass, m, n
_pass, n = input:apply(input.grammar.number)
if not (_pass) then
return false
end
if not (n > 0) then
return false
end
_pass, m = input:applyWithArgs(input.grammar.fact, n - 1)
if not (_pass) then
return false
end
return true, n * m
end)
end, arity = 0, grammar = nil, name = 'fact'})})
Factorial:merge(require('commons'))
print(Factorial.fact:matchMixed(5))
return Factorial
