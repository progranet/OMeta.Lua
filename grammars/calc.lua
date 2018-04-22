local Types = require('types')
local class, Any, Array = Types.class, Types.Any, Types.Array
local OMeta = require('ometa')
local Calc = OMeta.Grammar({_grammarName = 'Calc', exp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.addexp)
end, arity = 0, grammar = nil, name = 'exp'}), addexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:apply(input.grammar.addexp)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '+')) then
return false
end
return input:apply(input.grammar.mulexp)
end, function (input)
local _pass
if not (input:apply(input.grammar.addexp)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '-')) then
return false
end
return input:apply(input.grammar.mulexp)
end, input.grammar.mulexp)
end, arity = 0, grammar = nil, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:apply(input.grammar.mulexp)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '*')) then
return false
end
return input:apply(input.grammar.primexp)
end, function (input)
local _pass
if not (input:apply(input.grammar.mulexp)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '/')) then
return false
end
return input:apply(input.grammar.primexp)
end, input.grammar.primexp)
end, arity = 0, grammar = nil, name = 'mulexp'}), primexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.exactly, '(')) then
return false
end
if not (input:apply(input.grammar.exp)) then
return false
end
return input:applyWithArgs(input.grammar.exactly, ')')
end, input.grammar.numstr)
end, arity = 0, grammar = nil, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.exactly, '-')
end)) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end, arity = 0, grammar = nil, name = 'numstr'})})
Calc:merge(require('grammar_commons'))
local EvalCalc = OMeta.Grammar({_grammarName = 'EvalCalc', exp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.addexp)
end, arity = 0, grammar = nil, name = 'exp'}), addexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.addexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '+')) then
return false
end
_pass, r = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
return true, l + r
end, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.addexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '-')) then
return false
end
_pass, r = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
return true, l - r
end, input.grammar.mulexp)
end, arity = 0, grammar = nil, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '*')) then
return false
end
_pass, r = input:apply(input.grammar.primexp)
if not (_pass) then
return false
end
return true, l * r
end, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '/')) then
return false
end
_pass, r = input:apply(input.grammar.primexp)
if not (_pass) then
return false
end
return true, l / r
end, input.grammar.primexp)
end, arity = 0, grammar = nil, name = 'mulexp'}), primexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, exp
if not (input:applyWithArgs(input.grammar.exactly, '(')) then
return false
end
_pass, exp = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, ')')) then
return false
end
return true, exp
end, input.grammar.numstr)
end, arity = 0, grammar = nil, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
local _pass, digits
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, digits = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.exactly, '-')
end)) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end)
if not (_pass) then
return false
end
return true, tonumber(digits)
end)
end, arity = 0, grammar = nil, name = 'numstr'})})
EvalCalc:merge(require('grammar_commons'))
local TableTreeCalc = OMeta.Grammar({_grammarName = 'TableTreeCalc', exp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.addexp)
end, arity = 0, grammar = nil, name = 'exp'}), addexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.addexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '+')) then
return false
end
_pass, r = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
return true, {'+', l, r}
end, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.addexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '-')) then
return false
end
_pass, r = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
return true, {'-', l, r}
end, input.grammar.mulexp)
end, arity = 0, grammar = nil, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '*')) then
return false
end
_pass, r = input:apply(input.grammar.primexp)
if not (_pass) then
return false
end
return true, {'*', l, r}
end, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '/')) then
return false
end
_pass, r = input:apply(input.grammar.primexp)
if not (_pass) then
return false
end
return true, {'/', l, r}
end, input.grammar.primexp)
end, arity = 0, grammar = nil, name = 'mulexp'}), primexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, exp
if not (input:applyWithArgs(input.grammar.exactly, '(')) then
return false
end
_pass, exp = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, ')')) then
return false
end
return true, exp
end, input.grammar.numstr)
end, arity = 0, grammar = nil, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
local _pass, digits
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, digits = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.exactly, '-')
end)) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end)
if not (_pass) then
return false
end
return true, tonumber(digits)
end)
end, arity = 0, grammar = nil, name = 'numstr'})})
TableTreeCalc:merge(require('grammar_commons'))
local BinOp = class({name = 'BinOp', super = {Any}})
local OpTreeCalc = OMeta.Grammar({_grammarName = 'OpTreeCalc', exp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.addexp)
end, arity = 0, grammar = nil, name = 'exp'}), addexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.addexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "+")) then
return false
end
_pass, r = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
return true, BinOp({operator = 'add', left = l, right = r})
end, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.addexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "-")) then
return false
end
_pass, r = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
return true, BinOp({operator = 'sub', left = l, right = r})
end, input.grammar.mulexp)
end, arity = 0, grammar = nil, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "*")) then
return false
end
_pass, r = input:apply(input.grammar.primexp)
if not (_pass) then
return false
end
return true, BinOp({operator = 'mul', left = l, right = r})
end, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "/")) then
return false
end
_pass, r = input:apply(input.grammar.primexp)
if not (_pass) then
return false
end
return true, BinOp({operator = 'div', left = l, right = r})
end, input.grammar.primexp)
end, arity = 0, grammar = nil, name = 'mulexp'}), primexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, exp
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
_pass, exp = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
return true, exp
end, input.grammar.numstr)
end, arity = 0, grammar = nil, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
local _pass, digits
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
_pass, digits = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.token, "-")
end)) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end)
if not (_pass) then
return false
end
return true, tonumber(digits)
end)
end, arity = 0, grammar = nil, name = 'numstr'}), special = OMeta.Rule({behavior = function (input)
local _pass
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
end, arity = 0, grammar = nil, name = 'special'})})
OpTreeCalc:merge(require('grammar_commons'))
local Aux = require('auxiliary')
local MixedOTCalc = OMeta.Grammar({_grammarName = 'MixedOTCalc', primexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, BinOp, OpTreeCalc.primexp)
end, arity = 0, grammar = nil, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.number, OpTreeCalc.numstr)
end, arity = 0, grammar = nil, name = 'numstr'}), eval = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, opr
_pass, opr = input:applyWithArgs(input.grammar.andPredicate, BinOp)
if not (_pass) then
return false
end
return input:applyWithArgs(Aux.apply, opr.operator, input.grammar.unknown)
end, function (input)
local _pass, num
_pass, num = input:apply(input.grammar.number)
if not (_pass) then
return false
end
return true, num
end, function (input)
local _pass, any
_pass, any = input:apply(input.grammar.anything)
if not (_pass) then
return false
end
return error('unexpected expression: ' .. tostring(any))
end)
end, arity = 0, grammar = nil, name = 'eval'}), add = OMeta.Rule({behavior = function (input)
local _pass, right, left
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _state = input.stream
input.stream = input.stream:property('left')
_pass, left = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
if not (_pass) then
return false
end
local _state = input.stream
input.stream = input.stream:property('right')
_pass, right = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
return _pass, right
end)
end)) then
return false
end
print('+', left, right)
return true, left + right
end)
end, arity = 0, grammar = nil, name = 'add'}), sub = OMeta.Rule({behavior = function (input)
local _pass, right, left
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _state = input.stream
input.stream = input.stream:property('left')
_pass, left = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
if not (_pass) then
return false
end
local _state = input.stream
input.stream = input.stream:property('right')
_pass, right = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
return _pass, right
end)
end)) then
return false
end
print('-', left, right)
return true, left - right
end)
end, arity = 0, grammar = nil, name = 'sub'}), mul = OMeta.Rule({behavior = function (input)
local _pass, right, left
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _state = input.stream
input.stream = input.stream:property('left')
_pass, left = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
if not (_pass) then
return false
end
local _state = input.stream
input.stream = input.stream:property('right')
_pass, right = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
return _pass, right
end)
end)) then
return false
end
print('*', left, right)
return true, left * right
end)
end, arity = 0, grammar = nil, name = 'mul'}), div = OMeta.Rule({behavior = function (input)
local _pass, right, left
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _state = input.stream
input.stream = input.stream:property('left')
_pass, left = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
if not (_pass) then
return false
end
local _state = input.stream
input.stream = input.stream:property('right')
_pass, right = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
return _pass, right
end)
end)) then
return false
end
print('/', left, right)
return true, left / right
end)
end, arity = 0, grammar = nil, name = 'div'}), unknown = OMeta.Rule({behavior = function (input)
local _pass, operator
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
local _state = input.stream
input.stream = input.stream:property('operator')
_pass, operator = input:applyWithArgs(input.grammar.choice, input.grammar.anything)
input.stream = _state
return _pass, operator
end)) then
return false
end
return error('unexpected operator: ' .. operator)
end)
end, arity = 0, grammar = nil, name = 'unknown'})})
MixedOTCalc:merge(OpTreeCalc)
MixedOTCalc.primexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.andPredicate, BinOp)) then
return false
end
return input:applyWithArgs(input.grammar.object, nil, function (input)
local _state = input.stream
input.stream = input.stream:property('operator')
_pass = input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, 'add')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'sub')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'mul')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'div')
end)
input.stream = _state
return _pass
end)
end, function (input)
local _pass, opr
_pass, opr = input:apply(BinOp)
if not (_pass) then
return false
end
return opr.operator and error('unexpected operator: ' .. opr.operator) or error('operator expected')
end, OpTreeCalc.primexp)
end, arity = 0, grammar = MixedOTCalc, name = 'primexp'})
local AddOp = class({name = 'AddOp', super = {BinOp}})
local SubOp = class({name = 'SubOp', super = {BinOp}})
local MulOp = class({name = 'MulOp', super = {BinOp}})
local DivOp = class({name = 'DivOp', super = {BinOp}})
local AstCalc = OMeta.Grammar({_grammarName = 'AstCalc', exp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.addexp)
end, arity = 0, grammar = nil, name = 'exp'}), addexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.addexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "+")) then
return false
end
_pass, r = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
return true, AddOp({left = l, right = r})
end, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.addexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "-")) then
return false
end
_pass, r = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
return true, SubOp({left = l, right = r})
end, input.grammar.mulexp)
end, arity = 0, grammar = nil, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "*")) then
return false
end
_pass, r = input:apply(input.grammar.primexp)
if not (_pass) then
return false
end
return true, MulOp({left = l, right = r})
end, function (input)
local _pass, l, r
_pass, l = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "/")) then
return false
end
_pass, r = input:apply(input.grammar.primexp)
if not (_pass) then
return false
end
return true, DivOp({left = l, right = r})
end, input.grammar.primexp)
end, arity = 0, grammar = nil, name = 'mulexp'}), primexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, exp
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
_pass, exp = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
return true, exp
end, input.grammar.numstr)
end, arity = 0, grammar = nil, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
local _pass, digits
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
_pass, digits = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.token, "-")
end)) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end)
if not (_pass) then
return false
end
return true, tonumber(digits)
end)
end, arity = 0, grammar = nil, name = 'numstr'}), special = OMeta.Rule({behavior = function (input)
local _pass
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
end, arity = 0, grammar = nil, name = 'special'})})
AstCalc:merge(require('grammar_commons'))
local MixedAstCalc = OMeta.Grammar({_grammarName = 'MixedAstCalc', primexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, BinOp, AstCalc.primexp)
end, arity = 0, grammar = nil, name = 'primexp'}), numstr = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.number, AstCalc.numstr)
end, arity = 0, grammar = nil, name = 'numstr'}), eval = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, opr
_pass, opr = input:applyWithArgs(input.grammar.andPredicate, BinOp)
if not (_pass) then
return false
end
return input:applyWithArgs(Aux.apply, getType(opr), input.grammar.unknown)
end, function (input)
local _pass, num
_pass, num = input:apply(input.grammar.number)
if not (_pass) then
return false
end
return true, num
end, function (input)
local _pass, any
_pass, any = input:apply(input.grammar.anything)
if not (_pass) then
return false
end
return error('unexpected expression: ' .. tostring(any))
end)
end, arity = 0, grammar = nil, name = 'eval'}), [AddOp] = OMeta.Rule({behavior = function (input)
local _pass, right, left
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _state = input.stream
input.stream = input.stream:property('left')
_pass, left = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
if not (_pass) then
return false
end
local _state = input.stream
input.stream = input.stream:property('right')
_pass, right = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
return _pass, right
end)
end)) then
return false
end
print('+', left, right)
return true, left + right
end)
end, arity = 0, grammar = nil, name = 'AddOp'}), [SubOp] = OMeta.Rule({behavior = function (input)
local _pass, right, left
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _state = input.stream
input.stream = input.stream:property('left')
_pass, left = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
if not (_pass) then
return false
end
local _state = input.stream
input.stream = input.stream:property('right')
_pass, right = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
return _pass, right
end)
end)) then
return false
end
print('-', left, right)
return true, left - right
end)
end, arity = 0, grammar = nil, name = 'SubOp'}), [MulOp] = OMeta.Rule({behavior = function (input)
local _pass, right, left
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _state = input.stream
input.stream = input.stream:property('left')
_pass, left = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
if not (_pass) then
return false
end
local _state = input.stream
input.stream = input.stream:property('right')
_pass, right = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
return _pass, right
end)
end)) then
return false
end
print('*', left, right)
return true, left * right
end)
end, arity = 0, grammar = nil, name = 'MulOp'}), [DivOp] = OMeta.Rule({behavior = function (input)
local _pass, right, left
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.object, nil, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _state = input.stream
input.stream = input.stream:property('left')
_pass, left = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
if not (_pass) then
return false
end
local _state = input.stream
input.stream = input.stream:property('right')
_pass, right = input:applyWithArgs(input.grammar.choice, input.grammar.eval)
input.stream = _state
return _pass, right
end)
end)) then
return false
end
print('/', left, right)
return true, left / right
end)
end, arity = 0, grammar = nil, name = 'DivOp'}), unknown = OMeta.Rule({behavior = function (input)
local _pass, opr
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, opr = input:apply(input.grammar.anything)
if not (_pass) then
return false
end
return error('unexpected operation kind: ' .. tostring(opr))
end)
end, arity = 0, grammar = nil, name = 'unknown'})})
MixedAstCalc:merge(AstCalc)
return {Calc = Calc, EvalCalc = EvalCalc, TableTreeCalc = TableTreeCalc, BinOp = BinOp, OpTreeCalc = OpTreeCalc, MixedOTCalc = MixedOTCalc, AddOp = AddOp, SubOp = SubOp, MulOp = MulOp, DivOp = DivOp, AstCalc = AstCalc, MixedAstCalc = MixedAstCalc}
