local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local Types = require('types')
local Any, Array = Types.Any, Types.Array
local OMeta = require('ometa')
local utils = require('utils')
local asc = require('abstractsyntax_commons')
local Literal, NilLiteral, BooleanLiteral, NumberLiteral, IntegerLiteral, RealLiteral, StringLiteral, Name, Keyword, Special, Node, Statement, Expression, Control, Iterative, Invocation = asc.Literal, asc.NilLiteral, asc.BooleanLiteral, asc.NumberLiteral, asc.IntegerLiteral, asc.RealLiteral, asc.StringLiteral, asc.Name, asc.Keyword, asc.Special, asc.Node, asc.Statement, asc.Expression, asc.Control, asc.Iterative, asc.Invocation
local las = require('lua_abstractsyntax')
local Get, Set, Group, Block, Chunk, Do, While, Repeat, If, ElseIf, For, ForIn, Function, MethodStatement, FunctionStatement, FunctionExpression, Return, Break, LastStatement, Call, Send, BinaryOperation, UnaryOperation, GetProperty, VariableArguments, TableConstructor, SetProperty, Goto, Label = las.Get, las.Set, las.Group, las.Block, las.Chunk, las.Do, las.While, las.Repeat, las.If, las.ElseIf, las.For, las.ForIn, las.Function, las.MethodStatement, las.FunctionStatement, las.FunctionExpression, las.Return, las.Break, las.LastStatement, las.Call, las.Send, las.BinaryOperation, las.UnaryOperation, las.GetProperty, las.VariableArguments, las.TableConstructor, las.SetProperty, las.lua52.Goto, las.lua52.Label
local Commons = require('grammar_commons')
local LuaGrammar = OMeta.Grammar({_grammarName = 'LuaGrammar', special = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[...]])
end, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[..]])
end, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[==]])
end, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[~=]])
end, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[>=]])
end, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[<=]])
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '>')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '<')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '=')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '.')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '(')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, ')')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '{')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '}')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '[')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, ']')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, ',')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, ';')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, ':')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '+')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '-')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '*')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '/')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '%')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '^')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '#')
end)
end, arity = 0, grammar = nil, name = 'special'}), keyword = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, 'nil')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'false')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'true')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'and')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'or')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'not')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'if')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'then')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'else')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'elseif')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'end')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'repeat')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'until')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'while')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'do')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'break')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'for')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'in')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'function')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'return')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'local')
end)
end, arity = 0, grammar = nil, name = 'keyword'}), chunk = OMeta.Rule({behavior = function (input)
local _pass, last, stats
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, stats = input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, s
_pass, s = input:apply(input.grammar.stat)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.token, ";")
end)) then
return false
end
return true, s
end)
end)
if not (_pass) then
return false
end
_pass, last = input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, s
_pass, s = input:apply(input.grammar.laststat)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.token, ";")
end)) then
return false
end
return true, s
end)
end)
if not (_pass) then
return false
end
return true, Chunk({statements = stats:append(last)})
end)
end, arity = 0, grammar = nil, name = 'chunk'}), block = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.chunk)
end, arity = 0, grammar = nil, name = 'block'}), stat = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, body
if not (input:applyWithArgs(input.grammar.token, "do")) then
return false
end
_pass, body = input:apply(input.grammar.block)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, Do({block = body})
end, function (input)
local _pass, cond, body
if not (input:applyWithArgs(input.grammar.token, "while")) then
return false
end
_pass, cond = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "do")) then
return false
end
_pass, body = input:apply(input.grammar.block)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, While({expression = cond, block = body})
end, function (input)
local _pass, cond, body
if not (input:applyWithArgs(input.grammar.token, "repeat")) then
return false
end
_pass, body = input:apply(input.grammar.block)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "until")) then
return false
end
_pass, cond = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
return true, Repeat({block = body, expression = cond})
end, function (input)
local _pass, elseBody, thenBody, elseIfs, ifCond
if not (input:applyWithArgs(input.grammar.token, "if")) then
return false
end
_pass, ifCond = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "then")) then
return false
end
_pass, thenBody = input:apply(input.grammar.block)
if not (_pass) then
return false
end
_pass, elseIfs = input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, elseIfCond, elseIfBody
if not (input:applyWithArgs(input.grammar.token, "elseif")) then
return false
end
_pass, elseIfCond = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "then")) then
return false
end
_pass, elseIfBody = input:apply(input.grammar.block)
if not (_pass) then
return false
end
return true, ElseIf({expression = elseIfCond, block = elseIfBody})
end)
end)
if not (_pass) then
return false
end
_pass, elseBody = input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.token, "else")) then
return false
end
return input:apply(input.grammar.block)
end, function (input)
local _pass
if not (input:apply(input.grammar.empty)) then
return false
end
return true, Chunk({statements = Array({})})
end)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, If({expression = ifCond, block = thenBody, elseIfs = elseIfs, elseBlock = elseBody})
end, function (input)
local _pass, startExp, var, stopExp, stepExp, body
if not (input:applyWithArgs(input.grammar.token, "for")) then
return false
end
_pass, var = input:apply(input.grammar.name)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
_pass, startExp = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ",")) then
return false
end
_pass, stopExp = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
_pass, stepExp = input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.token, ",")) then
return false
end
return input:apply(input.grammar.exp)
end, function (input)
local _pass
if not (input:apply(input.grammar.empty)) then
return false
end
return true, RealLiteral({1})
end)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "do")) then
return false
end
_pass, body = input:apply(input.grammar.block)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, For({name = var, startExpression = startExp, stopExpression = stopExp, stepExpression = stepExp, block = body})
end, function (input)
local _pass, vars, body, exps
if not (input:applyWithArgs(input.grammar.token, "for")) then
return false
end
_pass, vars = input:apply(input.grammar.namelist)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "in")) then
return false
end
_pass, exps = input:apply(input.grammar.explist)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "do")) then
return false
end
_pass, body = input:apply(input.grammar.block)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, ForIn({names = vars, expressions = exps, block = body})
end, function (input)
local _pass, mn, ns, body
if not (input:applyWithArgs(input.grammar.token, "function")) then
return false
end
_pass, ns = input:applyWithArgs(input.grammar.list, input.grammar.name, function (input)
return input:applyWithArgs(input.grammar.token, ".")
end, 1)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ":")) then
return false
end
_pass, mn = input:apply(input.grammar.name)
if not (_pass) then
return false
end
_pass, body = input:apply(input.grammar.funcbody)
if not (_pass) then
return false
end
return true, MethodStatement({context = ns, name = mn, arguments = body[1][1], variableArguments = body[1][2], block = body[2]})
end, function (input)
local _pass, body, ns
if not (input:applyWithArgs(input.grammar.token, "function")) then
return false
end
_pass, ns = input:applyWithArgs(input.grammar.list, input.grammar.name, function (input)
return input:applyWithArgs(input.grammar.token, ".")
end, 1)
if not (_pass) then
return false
end
_pass, body = input:apply(input.grammar.funcbody)
if not (_pass) then
return false
end
return true, FunctionStatement({isLocal = false, context = ns, arguments = body[1][1], variableArguments = body[1][2], block = body[2]})
end, function (input)
local _pass, body, n
if not (input:applyWithArgs(input.grammar.token, "local")) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "function")) then
return false
end
_pass, n = input:apply(input.grammar.name)
if not (_pass) then
return false
end
_pass, body = input:apply(input.grammar.funcbody)
if not (_pass) then
return false
end
return true, FunctionStatement({isLocal = true, name = n, arguments = body[1][1], variableArguments = body[1][2], block = body[2]})
end, function (input)
local _pass, names, exps
if not (input:applyWithArgs(input.grammar.token, "local")) then
return false
end
_pass, names = input:apply(input.grammar.namelist)
if not (_pass) then
return false
end
_pass, exps = input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
return input:apply(input.grammar.explist)
end, function (input)
local _pass
if not (input:apply(input.grammar.empty)) then
return false
end
return true, Array({})
end)
if not (_pass) then
return false
end
return true, Set({isLocal = true, names = names, expressions = exps})
end, function (input)
local _pass, names, exps
_pass, names = input:applyWithArgs(input.grammar.list, input.grammar.prefixexp, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, 1)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
_pass, exps = input:apply(input.grammar.explist)
if not (_pass) then
return false
end
return true, Set({isLocal = false, names = names, expressions = exps})
end, input.grammar.prefixexp)
end, arity = 0, grammar = nil, name = 'stat'}), laststat = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, exps
if not (input:applyWithArgs(input.grammar.token, "return")) then
return false
end
_pass, exps = input:applyWithArgs(input.grammar.choice, input.grammar.explist, function (input)
local _pass
if not (input:apply(input.grammar.empty)) then
return false
end
return true, Array({})
end)
if not (_pass) then
return false
end
return true, Return({expressions = exps})
end, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.token, "break")) then
return false
end
return true, Break({})
end)
end, arity = 0, grammar = nil, name = 'laststat'}), exp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.orexp)
end, arity = 0, grammar = nil, name = 'exp'}), orexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, op, l, r
_pass, l = input:apply(input.grammar.orexp)
if not (_pass) then
return false
end
_pass, op = input:applyWithArgs(input.grammar.token, "or")
if not (_pass) then
return false
end
_pass, r = input:apply(input.grammar.andexp)
if not (_pass) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, input.grammar.andexp)
end, arity = 0, grammar = nil, name = 'orexp'}), andexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, op, l, r
_pass, l = input:apply(input.grammar.andexp)
if not (_pass) then
return false
end
_pass, op = input:applyWithArgs(input.grammar.token, "and")
if not (_pass) then
return false
end
_pass, r = input:apply(input.grammar.eqexp)
if not (_pass) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, input.grammar.eqexp)
end, arity = 0, grammar = nil, name = 'andexp'}), eqexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, op, l, r
_pass, l = input:apply(input.grammar.eqexp)
if not (_pass) then
return false
end
_pass, op = input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, "==")
end, function (input)
return input:applyWithArgs(input.grammar.token, "~=")
end)
if not (_pass) then
return false
end
_pass, r = input:apply(input.grammar.relexp)
if not (_pass) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, input.grammar.relexp)
end, arity = 0, grammar = nil, name = 'eqexp'}), relexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, op, l, r
_pass, l = input:apply(input.grammar.relexp)
if not (_pass) then
return false
end
_pass, op = input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, ">=")
end, function (input)
return input:applyWithArgs(input.grammar.token, ">")
end, function (input)
return input:applyWithArgs(input.grammar.token, "<=")
end, function (input)
return input:applyWithArgs(input.grammar.token, "<")
end)
if not (_pass) then
return false
end
_pass, r = input:apply(input.grammar.addexp)
if not (_pass) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, input.grammar.addexp)
end, arity = 0, grammar = nil, name = 'relexp'}), addexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, op, l, r
_pass, l = input:apply(input.grammar.addexp)
if not (_pass) then
return false
end
_pass, op = input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, "+")
end, function (input)
return input:applyWithArgs(input.grammar.token, "-")
end)
if not (_pass) then
return false
end
_pass, r = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, input.grammar.mulexp)
end, arity = 0, grammar = nil, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, op, l, r
_pass, l = input:apply(input.grammar.mulexp)
if not (_pass) then
return false
end
_pass, op = input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, "*")
end, function (input)
return input:applyWithArgs(input.grammar.token, "/")
end, function (input)
return input:applyWithArgs(input.grammar.token, "^")
end, function (input)
return input:applyWithArgs(input.grammar.token, "%")
end, function (input)
return input:applyWithArgs(input.grammar.token, "..")
end)
if not (_pass) then
return false
end
_pass, r = input:apply(input.grammar.unary)
if not (_pass) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, input.grammar.unary)
end, arity = 0, grammar = nil, name = 'mulexp'}), unary = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, op, c
_pass, op = input:applyWithArgs(input.grammar.token, "-")
if not (_pass) then
return false
end
_pass, c = input:apply(input.grammar.primexp)
if not (_pass) then
return false
end
return true, UnaryOperation({context = c, name = op})
end, function (input)
local _pass, op, c
_pass, op = input:applyWithArgs(input.grammar.token, "not")
if not (_pass) then
return false
end
_pass, c = input:apply(input.grammar.unary)
if not (_pass) then
return false
end
return true, UnaryOperation({context = c, name = op})
end, function (input)
local _pass, op, c
_pass, op = input:applyWithArgs(input.grammar.token, "#")
if not (_pass) then
return false
end
_pass, c = input:apply(input.grammar.primexp)
if not (_pass) then
return false
end
return true, UnaryOperation({context = c, name = op})
end, input.grammar.primexp)
end, arity = 0, grammar = nil, name = 'unary'}), primexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
return input:applyWithArgs(input.grammar.choice, input.grammar.nillit, input.grammar.boollit, input.grammar.reallit, input.grammar.hexlit, input.grammar.intlit, input.grammar.strlitA, input.grammar.strlitQ, input.grammar.strlitL)
end, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.token, "...")) then
return false
end
return true, VariableArguments({})
end, function (input)
local _pass, body
if not (input:applyWithArgs(input.grammar.token, "function")) then
return false
end
_pass, body = input:apply(input.grammar.funcbody)
if not (_pass) then
return false
end
return true, FunctionExpression({arguments = body[1][1], variableArguments = body[1][2], block = body[2]})
end, input.grammar.prefixexp, input.grammar.tableconstr)
end, arity = 0, grammar = nil, name = 'primexp'}), prefixexp = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, ctx
_pass, ctx = input:apply(input.grammar.prefixexp)
if not (_pass) then
return false
end
return input:applyWithArgs(input.grammar.suffixexp, ctx)
end, function (input)
local _pass, v
_pass, v = input:apply(input.grammar.name)
if not (_pass) then
return false
end
return true, Get({name = v})
end, function (input)
local _pass, e
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
_pass, e = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
return true, Group({expression = e})
end)
end, arity = 0, grammar = nil, name = 'prefixexp'}), suffixexp = OMeta.Rule({behavior = function (input, ctx)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, as
_pass, as = input:apply(input.grammar.args)
if not (_pass) then
return false
end
return true, Call({context = ctx, arguments = as})
end, function (input)
local _pass, as, n
if not (input:applyWithArgs(input.grammar.token, ":")) then
return false
end
_pass, n = input:apply(input.grammar.name)
if not (_pass) then
return false
end
_pass, as = input:apply(input.grammar.args)
if not (_pass) then
return false
end
return true, Send({context = ctx, name = n, arguments = as})
end, function (input)
local _pass, i
if not (input:applyWithArgs(input.grammar.token, "[")) then
return false
end
_pass, i = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
return true, GetProperty({context = ctx, index = i})
end, function (input)
local _pass, i
if not (input:applyWithArgs(input.grammar.token, ".")) then
return false
end
_pass, i = input:apply(input.grammar.name)
if not (_pass) then
return false
end
return true, GetProperty({context = ctx, index = i})
end)
end, arity = 1, grammar = nil, name = 'suffixexp'}), args = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, as
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
_pass, as = input:applyWithArgs(input.grammar.choice, input.grammar.explist, function (input)
local _pass
if not (input:apply(input.grammar.empty)) then
return false
end
return true, Array({})
end)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
return true, as
end, function (input)
local _pass, a
_pass, a = input:apply(input.grammar.tableconstr)
if not (_pass) then
return false
end
return true, Array({a})
end, function (input)
local _pass, a
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
_pass, a = input:applyWithArgs(input.grammar.choice, input.grammar.strlitA, input.grammar.strlitQ, input.grammar.strlitL)
if not (_pass) then
return false
end
return true, Array({a})
end)
end, arity = 0, grammar = nil, name = 'args'}), funcbody = OMeta.Rule({behavior = function (input)
local _pass, params, body
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
_pass, params = input:apply(input.grammar.parlist)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
_pass, body = input:apply(input.grammar.block)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, {params, body}
end)
end, arity = 0, grammar = nil, name = 'funcbody'}), parlist = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, names, va
_pass, names = input:apply(input.grammar.namelist)
if not (_pass) then
return false
end
_pass, va = input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.token, ",")) then
return false
end
return input:applyWithArgs(input.grammar.token, "...")
end)
end)
if not (_pass) then
return false
end
return true, {names, va ~= nil}
end, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.token, "...")) then
return false
end
return true, {Array({}), true}
end, function (input)
local _pass
if not (input:apply(input.grammar.empty)) then
return false
end
return true, {Array({}), false}
end)
end, arity = 0, grammar = nil, name = 'parlist'}), namelist = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.list, input.grammar.name, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, 1)
end)
end, arity = 0, grammar = nil, name = 'namelist'}), explist = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.list, input.grammar.exp, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, 1)
end)
end, arity = 0, grammar = nil, name = 'explist'}), tableconstr = OMeta.Rule({behavior = function (input)
local _pass, fields
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "{")) then
return false
end
_pass, fields = input:apply(input.grammar.fieldlist)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "}")) then
return false
end
return true, TableConstructor({properties = fields})
end)
end, arity = 0, grammar = nil, name = 'tableconstr'}), fieldlist = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, fields
_pass, fields = input:applyWithArgs(input.grammar.list, input.grammar.field, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, function (input)
return input:applyWithArgs(input.grammar.token, ";")
end)
end, 1)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, function (input)
return input:applyWithArgs(input.grammar.token, ";")
end)
end)) then
return false
end
return true, fields
end, function (input)
local _pass
if not (input:apply(input.grammar.empty)) then
return false
end
return true, Array({})
end)
end, arity = 0, grammar = nil, name = 'fieldlist'}), field = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, i, v
if not (input:applyWithArgs(input.grammar.token, "[")) then
return false
end
_pass, i = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
_pass, v = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
return true, SetProperty({index = i, expression = v})
end, function (input)
local _pass, i, v
_pass, i = input:apply(input.grammar.name)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
_pass, v = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
return true, SetProperty({index = i, expression = v})
end, function (input)
local _pass, v
_pass, v = input:apply(input.grammar.exp)
if not (_pass) then
return false
end
return true, SetProperty({expression = v})
end)
end, arity = 0, grammar = nil, name = 'field'})})
LuaGrammar:merge(Commons)
return LuaGrammar
