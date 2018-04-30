local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local Types = require('types')
local Any, Array = Types.Any, Types.Array
local utils = require('utils')
local asc = require('abstractsyntax_commons')
local Literal, NilLiteral, BooleanLiteral, NumberLiteral, IntegerLiteral, RealLiteral, StringLiteral, Name, Keyword, Special, Node, Statement, Expression, Control, Iterative, Invocation = asc.Literal, asc.NilLiteral, asc.BooleanLiteral, asc.NumberLiteral, asc.IntegerLiteral, asc.RealLiteral, asc.StringLiteral, asc.Name, asc.Keyword, asc.Special, asc.Node, asc.Statement, asc.Expression, asc.Control, asc.Iterative, asc.Invocation
local las = require('lua_abstractsyntax')
local Get, Set, Group, Block, Chunk, Do, While, Repeat, If, ElseIf, For, ForIn, Function, MethodStatement, FunctionStatement, FunctionExpression, Return, Break, LastStatement, Call, Send, BinaryOperation, UnaryOperation, GetProperty, VariableArguments, TableConstructor, SetProperty, Goto, Label = las.Get, las.Set, las.Group, las.Block, las.Chunk, las.Do, las.While, las.Repeat, las.If, las.ElseIf, las.For, las.ForIn, las.Function, las.MethodStatement, las.FunctionStatement, las.FunctionExpression, las.Return, las.Break, las.LastStatement, las.Call, las.Send, las.BinaryOperation, las.UnaryOperation, las.GetProperty, las.VariableArguments, las.TableConstructor, las.SetProperty, las.lua52.Goto, las.lua52.Label
local omas = require('ometa_abstractsyntax')
local Binding, Application, Choice, Sequence, Lookahead, Exactly, Token, Subsequence, NotPredicate, AndPredicate, Optional, Many, Consumed, Loop, Anything, HostNode, HostPredicate, HostStatement, HostExpression, RuleApplication, Object, Property, Rule, RuleExpression, RuleStatement, Grammar, GrammarExpression, GrammarStatement = omas.Binding, omas.Application, omas.Choice, omas.Sequence, omas.Lookahead, omas.Exactly, omas.Token, omas.Subsequence, omas.NotPredicate, omas.AndPredicate, omas.Optional, omas.Many, omas.Consumed, omas.Loop, omas.Anything, omas.HostNode, omas.HostPredicate, omas.HostStatement, omas.HostExpression, omas.RuleApplication, omas.Object, omas.Property, omas.Rule, omas.RuleExpression, omas.RuleStatement, omas.Grammar, omas.GrammarExpression, omas.GrammarStatement
local OMeta = require('ometa')
local OMetaGrammar = require('ometa_grammar')
local OMetaInLuaGrammar
local LuaInOMetaGrammar = OMeta.Grammar({_grammarName = 'LuaInOMetaGrammar', special = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaGrammar.special, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[[?]])
end, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[[!]])
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '[')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, ']')
end)
end, arity = 0, grammar = nil, name = 'special'}), keyword = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, 'end')
end)
end, arity = 0, grammar = nil, name = 'keyword'}), node = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaGrammar.node, function (input)
local __pass__, exp
if not (input:applyWithArgs(input.grammar.token, "[?")) then
return false
end
__pass__, exp = input:applyForeign(OMetaInLuaGrammar, OMetaInLuaGrammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
return true, HostPredicate({value = exp})
end, function (input)
local __pass__, exp
if not (input:applyWithArgs(input.grammar.token, "[!")) then
return false
end
__pass__, exp = input:applyWithArgs(input.grammar.many, function (input)
return input:applyForeign(OMetaInLuaGrammar, OMetaInLuaGrammar.stat)
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
return true, HostStatement({value = exp})
end)
end, arity = 0, grammar = nil, name = 'node'}), primexp = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaGrammar.primexp, function (input)
local __pass__, exp
if not (input:applyWithArgs(input.grammar.token, "[")) then
return false
end
__pass__, exp = input:applyForeign(OMetaInLuaGrammar, OMetaInLuaGrammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
return true, HostExpression({value = exp})
end)
end, arity = 0, grammar = nil, name = 'primexp'}), prop = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaGrammar.prop, function (input)
local __pass__, exp, index
__pass__, index = input:applyWithArgs(input.grammar.choice, function (input)
local __pass__, e
if not (input:applyWithArgs(input.grammar.token, "[")) then
return false
end
__pass__, e = input:applyForeign(OMetaInLuaGrammar, OMetaInLuaGrammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
return true, e
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
__pass__, exp = input:apply(input.grammar.choiceDef)
if not (__pass__) then
return false
end
return true, Property({expression = exp, index = index})
end)
end, arity = 0, grammar = nil, name = 'prop'})})
LuaInOMetaGrammar:merge(OMetaGrammar)
local LuaGrammar = require('lua52_grammar')
local OMetaInLuaMixedGrammar
local function exp(...)
return OMetaInLuaMixedGrammar.exp:matchMixed(...)
end
OMetaInLuaGrammar = OMeta.Grammar({_grammarName = 'OMetaInLuaGrammar', keyword = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, LuaGrammar.keyword, function (input)
return input:applyWithArgs(input.grammar.exactly, 'ometa')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'rule')
end)
end, arity = 0, grammar = nil, name = 'keyword'}), stat = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
local __pass__, body, n
if not (input:applyWithArgs(input.grammar.token, "local")) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "ometa")) then
return false
end
__pass__, n = input:apply(input.grammar.name)
if not (__pass__) then
return false
end
__pass__, body = input:apply(input.grammar.grammarBody)
if not (__pass__) then
return false
end
return true, GrammarStatement({isLocal = true, name = Array({n}), rules = body})
end, function (input)
local __pass__, body, ns
if not (input:applyWithArgs(input.grammar.token, "ometa")) then
return false
end
__pass__, ns = input:applyWithArgs(input.grammar.list, input.grammar.name, function (input)
return input:applyWithArgs(input.grammar.token, ".")
end, 1)
if not (__pass__) then
return false
end
__pass__, body = input:apply(input.grammar.grammarBody)
if not (__pass__) then
return false
end
return true, GrammarStatement({isLocal = false, name = ns, rules = body})
end, function (input)
local __pass__, ns, body, n
if not (input:applyWithArgs(input.grammar.token, "rule")) then
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
__pass__, n = input:apply(input.grammar.name)
if not (__pass__) then
return false
end
__pass__, body = input:apply(input.grammar.ruleBody)
if not (__pass__) then
return false
end
return true, RuleStatement({namespace = ns, name = n, arguments = body[1][1], variableArguments = body[1][2], block = body[2]})
end, LuaGrammar.stat)
end, arity = 0, grammar = nil, name = 'stat'}), primexp = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, LuaGrammar.primexp, function (input)
local __pass__, literal
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
__pass__, literal = input:apply(input.grammar.strlitB)
if not (__pass__) then
return false
end
return true, exp([[string.interpolate(]], literal, [[)]])
end)
end, arity = 0, grammar = nil, name = 'primexp'}), args = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, LuaGrammar.args, function (input)
local __pass__
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
return input:apply(input.grammar.strlitB)
end)
end, arity = 0, grammar = nil, name = 'args'}), ruleBody = OMeta.Rule({behavior = function (input)
local __pass__, params, body
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
__pass__, body = input:applyForeign(LuaInOMetaGrammar, LuaInOMetaGrammar.choiceDef)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, {params, body}
end)
end, arity = 0, grammar = nil, name = 'ruleBody'}), grammarBody = OMeta.Rule({behavior = function (input)
local __pass__, rules
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "{")) then
return false
end
__pass__, rules = input:applyWithArgs(input.grammar.list, input.grammar.innerRuleBody, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, function (input)
return input:applyWithArgs(input.grammar.token, ";")
end)
end)
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
if not (input:applyWithArgs(input.grammar.token, "}")) then
return false
end
return true, rules
end)
end, arity = 0, grammar = nil, name = 'grammarBody'}), innerRuleBody = OMeta.Rule({behavior = function (input)
local __pass__, params, body, index
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, index = input:applyWithArgs(input.grammar.choice, input.grammar.name, function (input)
local __pass__, __result__
if not (input:applyWithArgs(input.grammar.token, "[")) then
return false
end
__pass__, __result__ = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
return true, __result__
end)
if not (__pass__) then
return false
end
__pass__, params = input:applyWithArgs(input.grammar.choice, function (input)
local __pass__, __result__
if not (input:applyWithArgs(input.grammar.token, "(")) then
return false
end
__pass__, __result__ = input:apply(input.grammar.parlist)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, ")")) then
return false
end
return true, __result__
end, function (input)
local __pass__
if not (input:apply(input.grammar.empty)) then
return false
end
return true, {Array({}), false}
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "=")) then
return false
end
__pass__, body = input:applyForeign(LuaInOMetaGrammar, LuaInOMetaGrammar.choiceDef)
if not (__pass__) then
return false
end
return true, RuleExpression({name = index, arguments = params[1], variableArguments = params[2], block = body})
end)
end, arity = 0, grammar = nil, name = 'innerRuleBody'}), strlitB = OMeta.Rule({behavior = function (input)
local __pass__, slices, last
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '`')) then
return false
end
__pass__, slices = input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local __pass__, s, e
__pass__, s = input:apply(input.grammar.slice)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '$')) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "{")) then
return false
end
__pass__, e = input:apply(input.grammar.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "}")) then
return false
end
return true, Array({s, e})
end)
end)
if not (__pass__) then
return false
end
__pass__, last = input:apply(input.grammar.slice)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '`')) then
return false
end
return true, slices:flatten():append(last)
end)
end, arity = 0, grammar = nil, name = 'strlitB'}), slice = OMeta.Rule({behavior = function (input)
local __pass__, str
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, input.grammar.escchar, function (input)
local __pass__
if not (input:applyWithArgs(input.grammar.notPredicate, '`')) then
return false
end
if not (input:applyWithArgs(input.grammar.notPredicate, '$')) then
return false
end
return input:apply(input.grammar.char)
end)
end)
end)
if not (__pass__) then
return false
end
return true, StringLiteral({str, ldelim = '[[', rdelim = ']]'})
end)
end, arity = 0, grammar = nil, name = 'slice'})})
OMetaInLuaGrammar:merge(LuaGrammar)
OMetaInLuaMixedGrammar = OMeta.Grammar({_grammarName = 'OMetaInLuaMixedGrammar', name = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.name, Name)
end, arity = 0, grammar = nil, name = 'name'}), token = OMeta.Rule({behavior = function (input, str)
local __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(OMetaInLuaGrammar.token, str)
end, function (input)
local __pass__, token
__pass__, token = input:applyWithArgs(input.grammar.choice, Keyword, Special)
if not (__pass__) then
return false
end
if not (token[1] == str) then
return false
end
return true, token
end)
end, arity = 1, grammar = nil, name = 'token'}), chunk = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, Chunk, function (input)
local __pass__, stats
__pass__, stats = input:apply(Array)
if not (__pass__) then
return false
end
return true, Chunk({statements = stats})
end, OMetaInLuaGrammar.chunk)
end, arity = 0, grammar = nil, name = 'chunk'}), stat = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.stat, Do, While, Repeat, If, ElseIf, For, ForIn, MethodStatement, FunctionStatement, Set, Goto)
end, arity = 0, grammar = nil, name = 'stat'}), label = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.label, Label)
end, arity = 0, grammar = nil, name = 'label'}), laststat = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.laststat, Return, Break)
end, arity = 0, grammar = nil, name = 'laststat'}), namelist = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.namelist, Array)
end, arity = 0, grammar = nil, name = 'namelist'}), explist = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.explist, Array)
end, arity = 0, grammar = nil, name = 'explist'}), mulexp = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.mulexp, BinaryOperation)
end, arity = 0, grammar = nil, name = 'mulexp'}), unary = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.unary, UnaryOperation)
end, arity = 0, grammar = nil, name = 'unary'}), primexp = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.primexp, NilLiteral, BooleanLiteral, RealLiteral, StringLiteral, VariableArguments, FunctionExpression)
end, arity = 0, grammar = nil, name = 'primexp'}), prefixexp = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
local __pass__, ctx
__pass__, ctx = input:apply(input.grammar.prefixexp)
if not (__pass__) then
return false
end
return input:applyWithArgs(input.grammar.suffixexp, ctx)
end, Call, Send, GetProperty, Get, Group, OMetaInLuaGrammar.prefixexp)
end, arity = 0, grammar = nil, name = 'prefixexp'}), args = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.args, Array, function (input)
local __pass__, a
__pass__, a = input:apply(TableConstructor)
if not (__pass__) then
return false
end
return true, Array({a})
end, function (input)
local __pass__, a
__pass__, a = input:apply(StringLiteral)
if not (__pass__) then
return false
end
return true, Array({a})
end)
end, arity = 0, grammar = nil, name = 'args'}), tableconstr = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.tableconstr, TableConstructor)
end, arity = 0, grammar = nil, name = 'tableconstr'}), fieldlist = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.fieldlist, Array)
end, arity = 0, grammar = nil, name = 'fieldlist'}), field = OMeta.Rule({behavior = function (input)
local __pass__
return input:applyWithArgs(input.grammar.choice, OMetaInLuaGrammar.field, SetProperty)
end, arity = 0, grammar = nil, name = 'field'})})
OMetaInLuaMixedGrammar:merge(OMetaInLuaGrammar)
return {LuaInOMetaGrammar = LuaInOMetaGrammar, OMetaInLuaGrammar = OMetaInLuaGrammar, OMetaInLuaMixedGrammar = OMetaInLuaMixedGrammar}
