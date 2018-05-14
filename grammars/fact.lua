local OMeta = require('ometa')
local Factorial = OMeta.Grammar({_grammarName = 'Factorial', fact = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, 0)) then
return false
end
return true, 1
end, function (input)
local __pass__, m, n
__pass__, n = input:apply(input.grammar.number)
if not (__pass__) then
return false
end
if not (n > 0) then
return false
end
__pass__, m = input:applyWithArgs(input.grammar.fact, n - 1)
if not (__pass__) then
return false
end
return true, n * m
end)
end, arity = 0, grammar = Factorial, name = 'fact'})})
Factorial:merge(require('commons'))
print(Factorial.fact:matchMixed(5))
return Factorial
