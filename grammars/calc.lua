local OMeta = require('ometa')
local Types = require('types')
local class, Any, Array = Types.class, Types.Any, Types.Array
local Commons = require('grammar_commons')
local Calc = OMeta.Grammar({_grammarName = 'Calc', exp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.addexp)
end)
end, arity = 0, name = 'exp'}), addexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(input.grammar.addexp)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '+')) then
return false
end
return input:apply(input.grammar.mulexp)
end, function (input)
if not (input:apply(input.grammar.addexp)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '-')) then
return false
end
return input:apply(input.grammar.mulexp)
end, function (input)
return input:apply(input.grammar.mulexp)
end)
end, arity = 0, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(input.grammar.mulexp)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '*')) then
return false
end
return input:apply(input.grammar.primexp)
end, function (input)
if not (input:apply(input.grammar.mulexp)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '/')) then
return false
end
return input:apply(input.grammar.primexp)
end, function (input)
return input:apply(input.grammar.primexp)
end)
end, arity = 0, name = 'mulexp'}), primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '(')) then
return false
end
if not (input:apply(input.grammar.exp)) then
return false
end
return input:applyWithArgs(input.grammar.exactly, ')')
end, function (input)
return input:apply(input.grammar.numstr)
end)
end, arity = 0, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.optional, '-')) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end, arity = 0, name = 'numstr'})})
Calc:merge(require('grammar_commons'))
Calc.exp:matchString('11*2-1')
local EvalCalc = OMeta.Grammar({_grammarName = 'EvalCalc', exp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.addexp)
end)
end, arity = 0, name = 'exp'}), addexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.addexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '+')) then
return false
end
__pass__, r = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
return true, l + r
end, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.addexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '-')) then
return false
end
__pass__, r = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
return true, l - r
end, function (input)
return input:apply(input.grammar.mulexp)
end)
end, arity = 0, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '*')) then
return false
end
__pass__, r = input:apply(input.grammar.primexp)
if not (__pass__) then
return false
end
return true, l * r
end, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '/')) then
return false
end
__pass__, r = input:apply(input.grammar.primexp)
if not (__pass__) then
return false
end
return true, l / r
end, function (input)
return input:apply(input.grammar.primexp)
end)
end, arity = 0, name = 'mulexp'}), primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __result__, __pass__
if not (input:applyWithArgs(input.grammar.exactly, '(')) then
return false
end
__pass__, __result__ = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, ')')) then
return false
end
return true, __result__
end, function (input)
return input:apply(input.grammar.numstr)
end)
end, arity = 0, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.toNumber, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.optional, '-')) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end)
end)
end)
end, arity = 0, name = 'numstr'})})
EvalCalc:merge(Commons)
local result = EvalCalc.exp:matchString('11*2-1')
print(result)
local TableTreeCalc = OMeta.Grammar({_grammarName = 'TableTreeCalc', exp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.addexp)
end)
end, arity = 0, name = 'exp'}), addexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.addexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '+')) then
return false
end
__pass__, r = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
return true, {'+', l, r}
end, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.addexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '-')) then
return false
end
__pass__, r = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
return true, {'-', l, r}
end, function (input)
return input:apply(input.grammar.mulexp)
end)
end, arity = 0, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '*')) then
return false
end
__pass__, r = input:apply(input.grammar.primexp)
if not (__pass__) then
return false
end
return true, {'*', l, r}
end, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '/')) then
return false
end
__pass__, r = input:apply(input.grammar.primexp)
if not (__pass__) then
return false
end
return true, {'/', l, r}
end, function (input)
return input:apply(input.grammar.primexp)
end)
end, arity = 0, name = 'mulexp'}), primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __result__, __pass__
if not (input:applyWithArgs(input.grammar.exactly, '(')) then
return false
end
__pass__, __result__ = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, ')')) then
return false
end
return true, __result__
end, function (input)
return input:apply(input.grammar.numstr)
end)
end, arity = 0, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.toNumber, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.optional, '-')) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end)
end)
end)
end, arity = 0, name = 'numstr'})})
TableTreeCalc:merge(Commons)
local astTable = TableTreeCalc.exp:matchString('11*2-1')
local astRoot = Any(astTable)
print(astRoot)
local BinOp = class({name = 'BinOp', super = {Any}})
local OpTreeCalc = OMeta.Grammar({_grammarName = 'OpTreeCalc', exp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.addexp)
end)
end, arity = 0, name = 'exp'}), addexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.addexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "+")) then
return false
end
__pass__, r = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
return true, BinOp({operator = 'add', left = l, right = r})
end, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.addexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "-")) then
return false
end
__pass__, r = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
return true, BinOp({operator = 'sub', left = l, right = r})
end, function (input)
return input:apply(input.grammar.mulexp)
end)
end, arity = 0, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "*")) then
return false
end
__pass__, r = input:apply(input.grammar.primexp)
if not (__pass__) then
return false
end
return true, BinOp({operator = 'mul', left = l, right = r})
end, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "/")) then
return false
end
__pass__, r = input:apply(input.grammar.primexp)
if not (__pass__) then
return false
end
return true, BinOp({operator = 'div', left = l, right = r})
end, function (input)
return input:apply(input.grammar.primexp)
end)
end, arity = 0, name = 'mulexp'}), primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __result__, __pass__
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
__pass__, __result__ = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
return true, __result__
end, function (input)
return input:apply(input.grammar.numstr)
end)
end, arity = 0, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
return input:applyWithArgs(input.grammar.toNumber, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.token, "-")
end)) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end)
end)
end)
end, arity = 0, name = 'numstr'}), special = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, '+')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '-')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '*')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '/')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '(')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, ')')
end)
end, arity = 0, name = 'special'})})
OpTreeCalc:merge(Commons)
local Aux = require('auxiliary')
local MixedOTCalc = OMeta.Grammar({_grammarName = 'MixedOTCalc', primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(BinOp)
end, function (input)
return input:apply(OpTreeCalc.primexp)
end)
end, arity = 0, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.number)
end, function (input)
return input:apply(OpTreeCalc.numstr)
end)
end, arity = 0, name = 'numstr'}), eval = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local opr, __pass__
__pass__, opr = input:applyWithArgs(input.grammar.andPredicate, BinOp)
if not (__pass__) then
return false
end
return input:applyWithArgs(Aux.apply, opr.operator, input.grammar.unknown)
end, function (input)
return input:apply(input.grammar.number)
end, function (input)
return error('unexpected expression: ' .. tostring(input.stream._head))
end)
end, arity = 0, name = 'eval'}), add = OMeta.Rule({behavior = function (input)
local right, left, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, left = input:applyWithArgs(input.grammar.property, 'left', input.grammar.eval)
if not (__pass__) then
return false
end
__pass__, right = input:applyWithArgs(input.grammar.property, 'right', input.grammar.eval)
return __pass__, right
end)
end)) then
return false
end
print('+', left, right)
return true, left + right
end)
end, arity = 0, name = 'add'}), sub = OMeta.Rule({behavior = function (input)
local right, left, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, left = input:applyWithArgs(input.grammar.property, 'left', input.grammar.eval)
if not (__pass__) then
return false
end
__pass__, right = input:applyWithArgs(input.grammar.property, 'right', input.grammar.eval)
return __pass__, right
end)
end)) then
return false
end
print('-', left, right)
return true, left - right
end)
end, arity = 0, name = 'sub'}), mul = OMeta.Rule({behavior = function (input)
local right, left, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, left = input:applyWithArgs(input.grammar.property, 'left', input.grammar.eval)
if not (__pass__) then
return false
end
__pass__, right = input:applyWithArgs(input.grammar.property, 'right', input.grammar.eval)
return __pass__, right
end)
end)) then
return false
end
print('*', left, right)
return true, left * right
end)
end, arity = 0, name = 'mul'}), div = OMeta.Rule({behavior = function (input)
local right, left, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, left = input:applyWithArgs(input.grammar.property, 'left', input.grammar.eval)
if not (__pass__) then
return false
end
__pass__, right = input:applyWithArgs(input.grammar.property, 'right', input.grammar.eval)
return __pass__, right
end)
end)) then
return false
end
print('/', left, right)
return true, left / right
end)
end, arity = 0, name = 'div'}), unknown = OMeta.Rule({behavior = function (input)
local operator, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, operator = input:applyWithArgs(input.grammar.property, 'operator', input.grammar.anything)
return __pass__, operator
end)
end)) then
return false
end
return error('unexpected operator: ' .. operator)
end)
end, arity = 0, name = 'unknown'})})
MixedOTCalc:merge(OpTreeCalc)
MixedOTCalc.primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.andPredicate, BinOp)) then
return false
end
return input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.property, 'operator', function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, 'add')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'sub')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'mul')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'div')
end)
end)
end)
end, function (input)
local opr, __pass__
__pass__, opr = input:apply(BinOp)
if not (__pass__) then
return false
end
return opr.operator and error('unexpected operator: ' .. opr.operator) or error('operator expected')
end, function (input)
return input:apply(OpTreeCalc.primexp)
end)
end, arity = 0, name = 'primexp'})
local exp = BinOp({operator = 'mul', left = 2, right = BinOp({operator = 'add', left = 5, right = 6})})
local ast = MixedOTCalc.exp:matchMixed('2 * (', exp, ' - 1)')
print(ast)
print(MixedOTCalc.eval:matchMixed(ast))
local AddOp = class({name = 'AddOp', super = {BinOp}})
local SubOp = class({name = 'SubOp', super = {BinOp}})
local MulOp = class({name = 'MulOp', super = {BinOp}})
local DivOp = class({name = 'DivOp', super = {BinOp}})
local AstCalc = OMeta.Grammar({_grammarName = 'AstCalc', exp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.addexp)
end)
end, arity = 0, name = 'exp'}), addexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.addexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "+")) then
return false
end
__pass__, r = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
return true, AddOp({left = l, right = r})
end, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.addexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "-")) then
return false
end
__pass__, r = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
return true, SubOp({left = l, right = r})
end, function (input)
return input:apply(input.grammar.mulexp)
end)
end, arity = 0, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "*")) then
return false
end
__pass__, r = input:apply(input.grammar.primexp)
if not (__pass__) then
return false
end
return true, MulOp({left = l, right = r})
end, function (input)
local r, __pass__, l
__pass__, l = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "/")) then
return false
end
__pass__, r = input:apply(input.grammar.primexp)
if not (__pass__) then
return false
end
return true, DivOp({left = l, right = r})
end, function (input)
return input:apply(input.grammar.primexp)
end)
end, arity = 0, name = 'mulexp'}), primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __result__, __pass__
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
__pass__, __result__ = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
return true, __result__
end, function (input)
return input:apply(input.grammar.numstr)
end)
end, arity = 0, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
return input:applyWithArgs(input.grammar.toNumber, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.token, "-")
end)) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end)
end)
end)
end, arity = 0, name = 'numstr'}), special = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, '+')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '-')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '*')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '/')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '(')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, ')')
end)
end, arity = 0, name = 'special'})})
AstCalc:merge(Commons)
local MixedAstCalc = OMeta.Grammar({_grammarName = 'MixedAstCalc', primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(BinOp)
end, function (input)
return input:apply(AstCalc.primexp)
end)
end, arity = 0, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.number)
end, function (input)
return input:apply(AstCalc.numstr)
end)
end, arity = 0, name = 'numstr'}), eval = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local opr, __pass__
__pass__, opr = input:applyWithArgs(input.grammar.andPredicate, BinOp)
if not (__pass__) then
return false
end
return input:applyWithArgs(Aux.apply, getType(opr), input.grammar.unknown)
end, function (input)
return input:apply(input.grammar.number)
end, function (input)
local any, __pass__
__pass__, any = input:apply(input.grammar.anything)
if not (__pass__) then
return false
end
return error('unexpected expression: ' .. tostring(any))
end)
end, arity = 0, name = 'eval'}), [AddOp] = OMeta.Rule({behavior = function (input)
local right, left, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, left = input:applyWithArgs(input.grammar.property, 'left', input.grammar.eval)
if not (__pass__) then
return false
end
__pass__, right = input:applyWithArgs(input.grammar.property, 'right', input.grammar.eval)
return __pass__, right
end)
end)) then
return false
end
print('+', left, right)
return true, left + right
end)
end, arity = 0, name = 'AddOp'}), [SubOp] = OMeta.Rule({behavior = function (input)
local right, left, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, left = input:applyWithArgs(input.grammar.property, 'left', input.grammar.eval)
if not (__pass__) then
return false
end
__pass__, right = input:applyWithArgs(input.grammar.property, 'right', input.grammar.eval)
return __pass__, right
end)
end)) then
return false
end
print('-', left, right)
return true, left - right
end)
end, arity = 0, name = 'SubOp'}), [MulOp] = OMeta.Rule({behavior = function (input)
local right, left, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, left = input:applyWithArgs(input.grammar.property, 'left', input.grammar.eval)
if not (__pass__) then
return false
end
__pass__, right = input:applyWithArgs(input.grammar.property, 'right', input.grammar.eval)
return __pass__, right
end)
end)) then
return false
end
print('*', left, right)
return true, left * right
end)
end, arity = 0, name = 'MulOp'}), [DivOp] = OMeta.Rule({behavior = function (input)
local right, left, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, left = input:applyWithArgs(input.grammar.property, 'left', input.grammar.eval)
if not (__pass__) then
return false
end
__pass__, right = input:applyWithArgs(input.grammar.property, 'right', input.grammar.eval)
return __pass__, right
end)
end)) then
return false
end
print('/', left, right)
return true, left / right
end)
end, arity = 0, name = 'DivOp'}), unknown = OMeta.Rule({behavior = function (input)
local opr, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, opr = input:apply(input.grammar.anything)
if not (__pass__) then
return false
end
return error('unexpected operation kind: ' .. tostring(opr))
end)
end, arity = 0, name = 'unknown'})})
MixedAstCalc:merge(AstCalc)
local calc = function (...)
return MixedAstCalc.exp:matchMixed(...)
end
local eval = function (...)
return MixedAstCalc.eval:matchMixed(...)
end
local exp = calc([[2 * (5 + 6)]])
local ast = calc([[2 * (]], exp, [[ - 1)]])
print(ast)
print('result before:', eval(ast))
exp.left = calc([[20 / 5]])
print(ast)
print('result after:', eval(ast))
return {Calc = Calc, EvalCalc = EvalCalc, TableTreeCalc = TableTreeCalc, BinOp = BinOp, OpTreeCalc = OpTreeCalc, MixedOTCalc = MixedOTCalc, AddOp = AddOp, SubOp = SubOp, MulOp = MulOp, DivOp = DivOp, AstCalc = AstCalc, MixedAstCalc = MixedAstCalc}
