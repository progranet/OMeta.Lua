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
local OMetaInLua, OMetaInLuaExt
local LuaInOMeta = OMeta.Grammar({_grammarName = 'LuaInOMeta', special = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaGrammar.special)
end, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[[?]])
end, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[[!]])
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '[')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, ']')
end)
end, arity = 0, name = 'special'}), keyword = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, 'end')
end)
end, arity = 0, name = 'keyword'}), node = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaGrammar.node)
end, function (input)
local exp, __pass__
if not (input:applyWithArgs(input.grammar.token, "[?")) then
return false
end
__pass__, exp = input:applyForeign(OMetaInLuaExt, OMetaInLuaExt.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
return true, HostPredicate({value = exp})
end, function (input)
local exp, __pass__
if not (input:applyWithArgs(input.grammar.token, "[!")) then
return false
end
__pass__, exp = input:applyWithArgs(input.grammar.many, function (input)
return input:applyForeign(OMetaInLuaExt, OMetaInLuaExt.stat)
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
return true, HostStatement({value = exp})
end)
end, arity = 0, name = 'node'}), primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaGrammar.primexp)
end, function (input)
local exp, __pass__
if not (input:applyWithArgs(input.grammar.token, "[")) then
return false
end
__pass__, exp = input:applyForeign(OMetaInLuaExt, OMetaInLuaExt.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
return false
end
return true, HostExpression({value = exp})
end)
end, arity = 0, name = 'primexp'}), prop = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaGrammar.prop)
end, function (input)
local __pass__, exp, index
if not (input:applyWithArgs(input.grammar.token, "[")) then
return false
end
__pass__, index = input:applyForeign(OMetaInLuaExt, OMetaInLuaExt.exp)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "]")) then
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
end, arity = 0, name = 'prop'})})
LuaInOMeta:merge(OMetaGrammar)
local LuaGrammar = require('lua52_grammar')
local OMetaInLuaMixed
local function exp(...)
return OMetaInLuaMixed.exp:matchMixed(...)
end
OMetaInLua = OMeta.Grammar({_grammarName = 'OMetaInLua', keyword = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(LuaGrammar.keyword)
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'ometa')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'merges')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'rule')
end)
end, arity = 0, name = 'keyword'}), stat = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local body, __pass__, ms, n
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
__pass__, ms = input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "merges")) then
return false
end
return input:applyWithArgs(input.grammar.list, input.grammar.exp, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, 1)
end)
end)
if not (__pass__) then
return false
end
__pass__, body = input:apply(input.grammar.grammarBody)
if not (__pass__) then
return false
end
return true, GrammarStatement({isLocal = true, name = Array({n}), merged = ms or Array({}), rules = body})
end, function (input)
local body, ns, ms, __pass__
if not (input:applyWithArgs(input.grammar.token, "ometa")) then
return false
end
__pass__, ns = input:applyWithArgs(input.grammar.list, input.grammar.name, function (input)
return input:applyWithArgs(input.grammar.token, ".")
end, 1)
if not (__pass__) then
return false
end
__pass__, ms = input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "merges")) then
return false
end
return input:applyWithArgs(input.grammar.list, input.grammar.exp, function (input)
return input:applyWithArgs(input.grammar.token, ",")
end, 1)
end)
end)
if not (__pass__) then
return false
end
__pass__, body = input:apply(input.grammar.grammarBody)
if not (__pass__) then
return false
end
return true, GrammarStatement({isLocal = false, name = ns, merged = ms or Array({}), rules = body})
end, function (input)
local body, ns, __pass__, n
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
end, function (input)
return input:apply(LuaGrammar.stat)
end)
end, arity = 0, name = 'stat'}), primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(LuaGrammar.primexp)
end, function (input)
local literal, __pass__
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
__pass__, literal = input:apply(input.grammar.strlitB)
if not (__pass__) then
return false
end
return true, exp([[string.interpolate(]], literal, [[)]])
end)
end, arity = 0, name = 'primexp'}), args = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(LuaGrammar.args)
end, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
return input:apply(input.grammar.strlitB)
end)
end, arity = 0, name = 'args'}), ruleBody = OMeta.Rule({behavior = function (input)
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
__pass__, body = input:applyForeign(LuaInOMeta, LuaInOMeta.choiceDef)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "end")) then
return false
end
return true, {params, body}
end)
end, arity = 0, name = 'ruleBody'}), grammarBody = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.token, "{")) then
return false
end
__pass__, __result__ = input:applyWithArgs(input.grammar.list, input.grammar.innerRuleBody, function (input)
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
return true, __result__
end)
end, arity = 0, name = 'grammarBody'}), innerRuleBody = OMeta.Rule({behavior = function (input)
local params, __pass__, body, index
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, index = input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.name)
end, function (input)
local __result__, __pass__
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
local __result__, __pass__
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
__pass__, body = input:applyForeign(LuaInOMeta, LuaInOMeta.choiceDef)
if not (__pass__) then
return false
end
return true, RuleExpression({name = index, arguments = params[1], variableArguments = params[2], block = body})
end)
end, arity = 0, name = 'innerRuleBody'}), strlitB = OMeta.Rule({behavior = function (input)
local slices, __pass__, last
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
end, arity = 0, name = 'strlitB'}), slice = OMeta.Rule({behavior = function (input)
local str, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.escchar)
end, function (input)
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
end, arity = 0, name = 'slice'})})
OMetaInLua:merge(LuaGrammar)
OMetaInLuaExt = OMeta.Grammar({_grammarName = 'OMetaInLuaExt', special = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.special)
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '$')
end)
end, arity = 0, name = 'special'}), primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.primexp)
end, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "$")) then
return false
end
if not (input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, "^")
end, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[result]])
end)) then
return false
end
return true, exp([[__result__]])
end, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "$")) then
return false
end
if not (input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.token, ".")
end, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[head]])
end)) then
return false
end
return true, exp([[input.stream._head]])
end, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "$")) then
return false
end
if not (input:applyWithArgs(input.grammar.subsequence, [[index]])) then
return false
end
return true, exp([[input.stream._index]])
end, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "$")) then
return false
end
if not (input:applyWithArgs(input.grammar.subsequence, [[input]])) then
return false
end
return true, exp([[input]])
end, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "$")) then
return false
end
if not (input:applyWithArgs(input.grammar.subsequence, [[state]])) then
return false
end
return true, exp([[input.stream]])
end, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
if not (input:applyWithArgs(input.grammar.token, "$")) then
return false
end
if not (input:applyWithArgs(input.grammar.subsequence, [[source]])) then
return false
end
return true, exp([[input.stream._source]])
end)
end, arity = 0, name = 'primexp'})})
OMetaInLuaExt:merge(OMetaInLua)
OMetaInLuaMixed = OMeta.Grammar({_grammarName = 'OMetaInLuaMixed', name = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.name)
end, function (input)
return input:apply(Name)
end)
end, arity = 0, name = 'name'}), token = OMeta.Rule({behavior = function (input, str)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(OMetaInLua.token, str)
end, function (input)
local __result__, __pass__
__pass__, __result__ = input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(Keyword)
end, function (input)
return input:apply(Special)
end)
if not (__pass__) then
return false
end
if not ((__result__)[1] == str) then
return false
end
return (__result__)[1] == str, __result__
end)
end, arity = 1, name = 'token'}), chunk = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(Chunk)
end, function (input)
local stats, __pass__
__pass__, stats = input:apply(Array)
if not (__pass__) then
return false
end
return true, Chunk({statements = stats})
end, function (input)
return input:apply(OMetaInLua.chunk)
end)
end, arity = 0, name = 'chunk'}), stat = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.stat)
end, function (input)
return input:apply(Do)
end, function (input)
return input:apply(While)
end, function (input)
return input:apply(Repeat)
end, function (input)
return input:apply(If)
end, function (input)
return input:apply(ElseIf)
end, function (input)
return input:apply(For)
end, function (input)
return input:apply(ForIn)
end, function (input)
return input:apply(MethodStatement)
end, function (input)
return input:apply(FunctionStatement)
end, function (input)
return input:apply(Set)
end, function (input)
return input:apply(Goto)
end)
end, arity = 0, name = 'stat'}), label = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.label)
end, function (input)
return input:apply(Label)
end)
end, arity = 0, name = 'label'}), laststat = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.laststat)
end, function (input)
return input:apply(Return)
end, function (input)
return input:apply(Break)
end)
end, arity = 0, name = 'laststat'}), namelist = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.namelist)
end, function (input)
return input:apply(Array)
end)
end, arity = 0, name = 'namelist'}), explist = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.explist)
end, function (input)
return input:apply(Array)
end)
end, arity = 0, name = 'explist'}), mulexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.mulexp)
end, function (input)
return input:apply(BinaryOperation)
end)
end, arity = 0, name = 'mulexp'}), unary = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.unary)
end, function (input)
return input:apply(UnaryOperation)
end)
end, arity = 0, name = 'unary'}), primexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.primexp)
end, function (input)
return input:apply(NilLiteral)
end, function (input)
return input:apply(BooleanLiteral)
end, function (input)
return input:apply(RealLiteral)
end, function (input)
return input:apply(StringLiteral)
end, function (input)
return input:apply(VariableArguments)
end, function (input)
return input:apply(FunctionExpression)
end)
end, arity = 0, name = 'primexp'}), prefixexp = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local ctx, __pass__
__pass__, ctx = input:apply(input.grammar.prefixexp)
if not (__pass__) then
return false
end
return input:applyWithArgs(input.grammar.suffixexp, ctx)
end, function (input)
return input:apply(Call)
end, function (input)
return input:apply(Send)
end, function (input)
return input:apply(GetProperty)
end, function (input)
return input:apply(Get)
end, function (input)
return input:apply(Group)
end, function (input)
return input:apply(OMetaInLua.prefixexp)
end)
end, arity = 0, name = 'prefixexp'}), args = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.args)
end, function (input)
return input:apply(Array)
end, function (input)
local a, __pass__
__pass__, a = input:apply(TableConstructor)
if not (__pass__) then
return false
end
return true, Array({a})
end, function (input)
local a, __pass__
__pass__, a = input:apply(StringLiteral)
if not (__pass__) then
return false
end
return true, Array({a})
end)
end, arity = 0, name = 'args'}), tableconstr = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.tableconstr)
end, function (input)
return input:apply(TableConstructor)
end)
end, arity = 0, name = 'tableconstr'}), fieldlist = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.fieldlist)
end, function (input)
return input:apply(Array)
end)
end, arity = 0, name = 'fieldlist'}), field = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(OMetaInLua.field)
end, function (input)
return input:apply(SetProperty)
end)
end, arity = 0, name = 'field'})})
OMetaInLuaMixed:merge(OMetaInLua)
return {LuaInOMetaGrammar = LuaInOMeta, OMetaInLuaGrammar = OMetaInLua, OMetaInLuaExtGrammar = OMetaInLuaExt, OMetaInLuaMixedGrammar = OMetaInLuaMixed}
