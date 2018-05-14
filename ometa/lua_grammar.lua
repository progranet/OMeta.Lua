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
end, arity = 0, grammar = LuaGrammar, name = 'special'}), keyword = OMeta.Rule({behavior = function (input)
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
end, arity = 0, grammar = LuaGrammar, name = 'keyword'}), chunk = OMeta.Rule({behavior = function (input)
local __pass__, last, stats
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, stats = input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __result__, __pass__
__pass__, __result__ = input:apply(input.grammar.stat)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.token, ";")
end)) then
return false
end
return true, __result__
end)
end)
if not (__pass__) then
return false
end
__pass__, last = input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __result__, __pass__
__pass__, __result__ = input:apply(input.grammar.laststat)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.token, ";")
end)) then
return false
end
return true, __result__
end)
end)
if not (__pass__) then
return false
end
return true, Chunk({statements = stats:append(last)})
end)
end, arity = 0, grammar = LuaGrammar, name = 'chunk'}), block = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.chunk)
end)
end, arity = 0, grammar = LuaGrammar, name = 'block'}), stat = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local body, __pass__
if not (input:applyWithArgs(input.grammar.token, "do")) then
return false
end
__pass__, body = input:apply(input.grammar.block)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, Do({block = body})
end, function (input)
local cond, __pass__, body
if not (input:applyWithArgs(input.grammar.token, "while")) then
return false
end
__pass__, cond = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "do")) then
return false
end
__pass__, body = input:apply(input.grammar.block)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, While({expression = cond, block = body})
end, function (input)
local cond, body, __pass__
if not (input:applyWithArgs(input.grammar.token, "repeat")) then
return false
end
__pass__, body = input:apply(input.grammar.block)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "until")) then
return false
end
__pass__, cond = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
return true, Repeat({block = body, expression = cond})
end, function (input)
local elseIfs, elseBody, __pass__, thenBody, ifCond
if not (input:applyWithArgs(input.grammar.token, "if")) then
return false
end
__pass__, ifCond = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "then")) then
return false
end
__pass__, thenBody = input:apply(input.grammar.block)
if not (__pass__) then
return false
end
__pass__, elseIfs = input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __pass__, elseIfCond, elseIfBody
if not (input:applyWithArgs(input.grammar.token, "elseif")) then
return false
end
__pass__, elseIfCond = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "then")) then
return false
end
__pass__, elseIfBody = input:apply(input.grammar.block)
if not (__pass__) then
return false
end
return true, ElseIf({expression = elseIfCond, block = elseIfBody})
end)
end)
if not (__pass__) then
return false
end
__pass__, elseBody = input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "else")) then
return false
end
return input:apply(input.grammar.block)
end, function (input)
if not (input:apply(input.grammar.empty)) then
return false
end
return true, Chunk({statements = Array({})})
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, If({expression = ifCond, block = thenBody, elseIfs = elseIfs, elseBlock = elseBody})
end, function (input)
local startExp, var, stopExp, __pass__, body, stepExp
if not (input:applyWithArgs(input.grammar.token, "for")) then
return false
end
__pass__, var = input:apply(input.grammar.name)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
__pass__, startExp = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ",")) then
return false
end
__pass__, stopExp = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
__pass__, stepExp = input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, ",")) then
return false
end
return input:apply(input.grammar.exp)
end, function (input)
if not (input:apply(input.grammar.empty)) then
return false
end
return true, RealLiteral({1})
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "do")) then
return false
end
__pass__, body = input:apply(input.grammar.block)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, For({name = var, startExpression = startExp, stopExpression = stopExp, stepExpression = stepExp, block = body})
end, function (input)
local vars, __pass__, exps, body
if not (input:applyWithArgs(input.grammar.token, "for")) then
return false
end
__pass__, vars = input:apply(input.grammar.namelist)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "in")) then
return false
end
__pass__, exps = input:apply(input.grammar.explist)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "do")) then
return false
end
__pass__, body = input:apply(input.grammar.block)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, ForIn({names = vars, expressions = exps, block = body})
end, function (input)
local mn, ns, body, __pass__
if not (input:applyWithArgs(input.grammar.token, "function")) then
return false
end
__pass__, ns = input:applyWithArgs(input.grammar.list, input.grammar.name, function (input)
return input:applyWithArgs(input.grammar.token, ".")
end, 1)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ":")) then
return false
end
__pass__, mn = input:apply(input.grammar.name)
if not (__pass__) then
return false
end
__pass__, body = input:apply(input.grammar.funcbody)
if not (__pass__) then
return false
end
return true, MethodStatement({context = ns, name = mn, arguments = body[1][1], variableArguments = body[1][2], block = body[2]})
end, function (input)
local ns, body, __pass__
if not (input:applyWithArgs(input.grammar.token, "function")) then
return false
end
__pass__, ns = input:applyWithArgs(input.grammar.list, input.grammar.name, function (input)
return input:applyWithArgs(input.grammar.token, ".")
end, 1)
if not (__pass__) then
return false
end
__pass__, body = input:apply(input.grammar.funcbody)
if not (__pass__) then
return false
end
return true, FunctionStatement({isLocal = false, context = ns, arguments = body[1][1], variableArguments = body[1][2], block = body[2]})
end, function (input)
local __pass__, body, n
if not (input:applyWithArgs(input.grammar.token, "local")) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "function")) then
return false
end
__pass__, n = input:apply(input.grammar.name)
if not (__pass__) then
return false
end
__pass__, body = input:apply(input.grammar.funcbody)
if not (__pass__) then
return false
end
return true, FunctionStatement({isLocal = true, name = n, arguments = body[1][1], variableArguments = body[1][2], block = body[2]})
end, function (input)
local names, __pass__, exps
if not (input:applyWithArgs(input.grammar.token, "local")) then
return false
end
__pass__, names = input:apply(input.grammar.namelist)
if not (__pass__) then
return false
end
__pass__, exps = input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
return input:apply(input.grammar.explist)
end, function (input)
if not (input:apply(input.grammar.empty)) then
return false
end
return true, Array({})
end)
if not (__pass__) then
return false
end
return true, Set({isLocal = true, names = names, expressions = exps})
end, function (input)
local names, __pass__, exps
__pass__, names = input:applyWithArgs(input.grammar.list, input.grammar.prefixexp, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, 1)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
__pass__, exps = input:apply(input.grammar.explist)
if not (__pass__) then
return false
end
return true, Set({isLocal = false, names = names, expressions = exps})
end, function (input)
return input:apply(input.grammar.prefixexp)
end)
end, arity = 0, grammar = LuaGrammar, name = 'stat'}), laststat = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local exps, __pass__
if not (input:applyWithArgs(input.grammar.token, "return")) then
return false
end
__pass__, exps = input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.explist)
end, function (input)
if not (input:apply(input.grammar.empty)) then
return false
end
return true, Array({})
end)
if not (__pass__) then
return false
end
return true, Return({expressions = exps})
end, function (input)
if not (input:applyWithArgs(input.grammar.token, "break")) then
return false
end
return true, Break({})
end)
end, arity = 0, grammar = LuaGrammar, name = 'laststat'}), exp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.orexp)
end)
end, arity = 0, grammar = LuaGrammar, name = 'exp'}), orexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local op, __pass__, l, r
__pass__, l = input:apply(input.grammar.orexp)
if not (__pass__) then
return false
end
__pass__, op = input:applyWithArgs(input.grammar.token, "or")
if not (__pass__) then
return false
end
__pass__, r = input:apply(input.grammar.andexp)
if not (__pass__) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, function (input)
return input:apply(input.grammar.andexp)
end)
end, arity = 0, grammar = LuaGrammar, name = 'orexp'}), andexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local op, __pass__, l, r
__pass__, l = input:apply(input.grammar.andexp)
if not (__pass__) then
return false
end
__pass__, op = input:applyWithArgs(input.grammar.token, "and")
if not (__pass__) then
return false
end
__pass__, r = input:apply(input.grammar.eqexp)
if not (__pass__) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, function (input)
return input:apply(input.grammar.eqexp)
end)
end, arity = 0, grammar = LuaGrammar, name = 'andexp'}), eqexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local op, __pass__, l, r
__pass__, l = input:apply(input.grammar.eqexp)
if not (__pass__) then
return false
end
__pass__, op = input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, "==")
end, function (input)
return input:applyWithArgs(input.grammar.token, "~=")
end)
if not (__pass__) then
return false
end
__pass__, r = input:apply(input.grammar.relexp)
if not (__pass__) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, function (input)
return input:apply(input.grammar.relexp)
end)
end, arity = 0, grammar = LuaGrammar, name = 'eqexp'}), relexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local op, __pass__, l, r
__pass__, l = input:apply(input.grammar.relexp)
if not (__pass__) then
return false
end
__pass__, op = input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, ">=")
end, function (input)
return input:applyWithArgs(input.grammar.token, ">")
end, function (input)
return input:applyWithArgs(input.grammar.token, "<=")
end, function (input)
return input:applyWithArgs(input.grammar.token, "<")
end)
if not (__pass__) then
return false
end
__pass__, r = input:apply(input.grammar.addexp)
if not (__pass__) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, function (input)
return input:apply(input.grammar.addexp)
end)
end, arity = 0, grammar = LuaGrammar, name = 'relexp'}), addexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local op, __pass__, l, r
__pass__, l = input:apply(input.grammar.addexp)
if not (__pass__) then
return false
end
__pass__, op = input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, "+")
end, function (input)
return input:applyWithArgs(input.grammar.token, "-")
end)
if not (__pass__) then
return false
end
__pass__, r = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, function (input)
return input:apply(input.grammar.mulexp)
end)
end, arity = 0, grammar = LuaGrammar, name = 'addexp'}), mulexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local op, __pass__, l, r
__pass__, l = input:apply(input.grammar.mulexp)
if not (__pass__) then
return false
end
__pass__, op = input:applyWithArgs(input.grammar.choice, function (input)
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
if not (__pass__) then
return false
end
__pass__, r = input:apply(input.grammar.unary)
if not (__pass__) then
return false
end
return true, BinaryOperation({context = l, name = op, arguments = Array({r})})
end, function (input)
return input:apply(input.grammar.unary)
end)
end, arity = 0, grammar = LuaGrammar, name = 'mulexp'}), unary = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local op, __pass__, c
__pass__, op = input:applyWithArgs(input.grammar.token, "-")
if not (__pass__) then
return false
end
__pass__, c = input:apply(input.grammar.primexp)
if not (__pass__) then
return false
end
return true, UnaryOperation({context = c, name = op})
end, function (input)
local op, __pass__, c
__pass__, op = input:applyWithArgs(input.grammar.token, "not")
if not (__pass__) then
return false
end
__pass__, c = input:apply(input.grammar.unary)
if not (__pass__) then
return false
end
return true, UnaryOperation({context = c, name = op})
end, function (input)
local op, __pass__, c
__pass__, op = input:applyWithArgs(input.grammar.token, "#")
if not (__pass__) then
return false
end
__pass__, c = input:apply(input.grammar.primexp)
if not (__pass__) then
return false
end
return true, UnaryOperation({context = c, name = op})
end, function (input)
return input:apply(input.grammar.primexp)
end)
end, arity = 0, grammar = LuaGrammar, name = 'unary'}), primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.nillit)
end, function (input)
return input:apply(input.grammar.boollit)
end, function (input)
return input:apply(input.grammar.hexlit)
end, function (input)
return input:apply(input.grammar.reallit)
end, function (input)
return input:apply(input.grammar.intlit)
end, function (input)
return input:apply(input.grammar.strlitA)
end, function (input)
return input:apply(input.grammar.strlitQ)
end, function (input)
return input:apply(input.grammar.strlitL)
end)
end, function (input)
if not (input:applyWithArgs(input.grammar.token, "...")) then
return false
end
return true, VariableArguments({})
end, function (input)
local body, __pass__
if not (input:applyWithArgs(input.grammar.token, "function")) then
return false
end
__pass__, body = input:apply(input.grammar.funcbody)
if not (__pass__) then
return false
end
return true, FunctionExpression({arguments = body[1][1], variableArguments = body[1][2], block = body[2]})
end, function (input)
return input:apply(input.grammar.prefixexp)
end, function (input)
return input:apply(input.grammar.tableconstr)
end)
end, arity = 0, grammar = LuaGrammar, name = 'primexp'}), prefixexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local ctx, __pass__
__pass__, ctx = input:apply(input.grammar.prefixexp)
if not (__pass__) then
return false
end
return input:applyWithArgs(input.grammar.suffixexp, ctx)
end, function (input)
local v, __pass__
__pass__, v = input:apply(input.grammar.name)
if not (__pass__) then
return false
end
return true, Get({name = v})
end, function (input)
local e, __pass__
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
__pass__, e = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
return true, Group({expression = e})
end)
end, arity = 0, grammar = LuaGrammar, name = 'prefixexp'}), suffixexp = OMeta.Rule({behavior = function (input, ctx)
return input:applyWithArgs(input.grammar.choice, function (input)
local as, __pass__
__pass__, as = input:apply(input.grammar.args)
if not (__pass__) then
return false
end
return true, Call({context = ctx, arguments = as})
end, function (input)
local __pass__, as, n
if not (input:applyWithArgs(input.grammar.token, ":")) then
return false
end
__pass__, n = input:apply(input.grammar.name)
if not (__pass__) then
return false
end
__pass__, as = input:apply(input.grammar.args)
if not (__pass__) then
return false
end
return true, Send({context = ctx, name = n, arguments = as})
end, function (input)
local i, __pass__
if not (input:applyWithArgs(input.grammar.token, "[")) then
return false
end
__pass__, i = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
return true, GetProperty({context = ctx, index = i})
end, function (input)
local i, __pass__
if not (input:applyWithArgs(input.grammar.token, ".")) then
return false
end
__pass__, i = input:apply(input.grammar.name)
if not (__pass__) then
return false
end
return true, GetProperty({context = ctx, index = i})
end)
end, arity = 1, grammar = LuaGrammar, name = 'suffixexp'}), args = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __result__, __pass__
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
__pass__, __result__ = input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.explist)
end, function (input)
if not (input:apply(input.grammar.empty)) then
return false
end
return true, Array({})
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
return true, __result__
end, function (input)
local a, __pass__
__pass__, a = input:apply(input.grammar.tableconstr)
if not (__pass__) then
return false
end
return true, Array({a})
end, function (input)
local a, __pass__
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
__pass__, a = input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.strlitA)
end, function (input)
return input:apply(input.grammar.strlitQ)
end, function (input)
return input:apply(input.grammar.strlitL)
end)
if not (__pass__) then
return false
end
return true, Array({a})
end)
end, arity = 0, grammar = LuaGrammar, name = 'args'}), funcbody = OMeta.Rule({behavior = function (input)
local params, __pass__, body
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
__pass__, params = input:apply(input.grammar.parlist)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
__pass__, body = input:apply(input.grammar.block)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, {params, body}
end)
end, arity = 0, grammar = LuaGrammar, name = 'funcbody'}), parlist = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local names, __pass__, va
__pass__, names = input:apply(input.grammar.namelist)
if not (__pass__) then
return false
end
__pass__, va = input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, ",")) then
return false
end
return input:applyWithArgs(input.grammar.token, "...")
end)
end)
if not (__pass__) then
return false
end
return true, {names, va ~= nil}
end, function (input)
if not (input:applyWithArgs(input.grammar.token, "...")) then
return false
end
return true, {Array({}), true}
end, function (input)
if not (input:apply(input.grammar.empty)) then
return false
end
return true, {Array({}), false}
end)
end, arity = 0, grammar = LuaGrammar, name = 'parlist'}), namelist = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.list, input.grammar.name, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, 1)
end)
end, arity = 0, grammar = LuaGrammar, name = 'namelist'}), explist = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.list, input.grammar.exp, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, 1)
end)
end, arity = 0, grammar = LuaGrammar, name = 'explist'}), tableconstr = OMeta.Rule({behavior = function (input)
local fields, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "{")) then
return false
end
__pass__, fields = input:apply(input.grammar.fieldlist)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "}")) then
return false
end
return true, TableConstructor({properties = fields})
end)
end, arity = 0, grammar = LuaGrammar, name = 'tableconstr'}), fieldlist = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __result__, __pass__
__pass__, __result__ = input:applyWithArgs(input.grammar.list, input.grammar.field, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, function (input)
return input:applyWithArgs(input.grammar.token, ";")
end)
end, 1)
if not (__pass__) then
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
return true, __result__
end, function (input)
if not (input:apply(input.grammar.empty)) then
return false
end
return true, Array({})
end)
end, arity = 0, grammar = LuaGrammar, name = 'fieldlist'}), field = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local i, __pass__, v
if not (input:applyWithArgs(input.grammar.token, "[")) then
return false
end
__pass__, i = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
__pass__, v = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
return true, SetProperty({index = i, expression = v})
end, function (input)
local i, __pass__, v
__pass__, i = input:apply(input.grammar.name)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
__pass__, v = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
return true, SetProperty({index = i, expression = v})
end, function (input)
local v, __pass__
__pass__, v = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
return true, SetProperty({expression = v})
end)
end, arity = 0, grammar = LuaGrammar, name = 'field'})})
LuaGrammar:merge(Commons)
return LuaGrammar
