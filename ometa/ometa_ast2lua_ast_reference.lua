local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local Types = require('types')
local class = Types.class
local Any, Array = Types.Any, Types.Array
local asc = require('abstractsyntax_commons')
local Literal, NilLiteral, BooleanLiteral, NumberLiteral, IntegerLiteral, RealLiteral, StringLiteral, Name, Keyword, Special, Node, Statement, Expression, Control, Iterative, Invocation = asc.Literal, asc.NilLiteral, asc.BooleanLiteral, asc.NumberLiteral, asc.IntegerLiteral, asc.RealLiteral, asc.StringLiteral, asc.Name, asc.Keyword, asc.Special, asc.Node, asc.Statement, asc.Expression, asc.Control, asc.Iterative, asc.Invocation
local las = require('lua_abstractsyntax')
local Get, Set, Group, Block, Chunk, Do, While, Repeat, If, ElseIf, For, ForIn, Function, MethodStatement, FunctionStatement, FunctionExpression, Return, Break, LastStatement, Call, Send, BinaryOperation, UnaryOperation, GetProperty, VariableArguments, TableConstructor, SetProperty, Goto, Label = las.Get, las.Set, las.Group, las.Block, las.Chunk, las.Do, las.While, las.Repeat, las.If, las.ElseIf, las.For, las.ForIn, las.Function, las.MethodStatement, las.FunctionStatement, las.FunctionExpression, las.Return, las.Break, las.LastStatement, las.Call, las.Send, las.BinaryOperation, las.UnaryOperation, las.GetProperty, las.VariableArguments, las.TableConstructor, las.SetProperty, las.lua52.Goto, las.lua52.Label
local omas = require('ometa_abstractsyntax')
local OMetaNode, Binding, Application, Choice, Sequence, Lookahead, Exactly, Token, Subsequence, NotPredicate, AndPredicate, Optional, Many, Consumed, Loop, Anything, HostNode, HostPredicate, HostStatement, HostExpression, RuleApplication, Object, Property, Rule, RuleExpression, RuleStatement, Grammar, GrammarExpression, GrammarStatement = omas.OMetaNode, omas.Binding, omas.Application, omas.Choice, omas.Sequence, omas.Lookahead, omas.Exactly, omas.Token, omas.Subsequence, omas.NotPredicate, omas.AndPredicate, omas.Optional, omas.Many, omas.Consumed, omas.Loop, omas.Anything, omas.HostNode, omas.HostPredicate, omas.HostStatement, omas.HostExpression, omas.RuleApplication, omas.Object, omas.Property, omas.Rule, omas.RuleExpression, omas.RuleStatement, omas.Grammar, omas.GrammarExpression, omas.GrammarStatement
local toLuaAst
local rno = 0
local OMeta = require('ometa')
local Grammar = require('ometa_lua_grammar').OMetaInLuaMixedGrammar
local function exp(...)
local ast = Grammar.exp:matchMixed(...)
return ast
end
local function stat(...)
local ast = Grammar.stat:matchMixed(...)
return ast
end
local function laststat(...)
local ast = Grammar.laststat:matchMixed(...)
return ast
end
local luaContext = OMeta.use(Grammar):forString('')
local function isLuaKeyword(str)
return luaContext:applyWithArgs(Grammar.keyword, str)
end
local function name2ast(name, context)
if #name == 1 and (context == nil or not context.locals[name[1][1]]) then
local l1 = name[1][1]:sub(1, 1)
if not (l1 >= 'A' and l1 <= 'Z') then
return name2ast(Array({Name({'input'}), Name({'grammar'}), name[1]}), context)
end
end
local ast = Get({name = name[1]})
for i = 2, #name do
local n = name[i]
ast = GetProperty({context = ast, index = isLuaKeyword(n[1]) and StringLiteral({n[1]}) or n})
end
return ast
end
local Context
Context = class({name = 'Context', super = {Any}, constructor = function (class, init)
if init.locals == nil then
init.locals = {}
end
return init
end, newScope = function (self, props)
props = props or {}
props.scope = false
if not props.locals then
props.locals = {}
end
setmetatable(props.locals, {__index = self.locals})
setmetatable(props, {__index = self})
return props
end, new = function (self, props)
props = Context(props or {})
if not props.locals then
props.locals = self.locals
end
return props
end, declareLocals = function (self, stats)
local locals = Array({})
local i = #locals
for name in pairs(self.locals) do
i = i + 1
locals[i] = Name({name})
end
if i ~= 0 then
stats:prepend(stat([[local ]], locals, [[]]))
end
return stats
end})
function toLuaAst(node, context)
if context == nil then
context = Context({})
end
if OMetaNode:isInstance(node) then
return node:toLuaAst(context)
elseif Array:isInstance(node) then
local clone = Array({})
for i = 1, #node do
clone[i] = toLuaAst(node[i], context)
end
return clone
elseif Literal:isInstance(node) then
return node
end
local nodetype = getType(node)
if nodetype == nil then
return node
end
local clone = {}
for k, v in pairs(node) do
local l1 = (type(k) == 'string') and k:sub(1, 1)
if l1 and l1 >= 'a' and l1 <= 'z' then
context = context:new({parent = node, name = k})
clone[k] = toLuaAst(v, context)
else
clone[k] = v
end
end
return nodetype(clone)
end
function GrammarStatement:toLuaAst(context)
local props = Array({SetProperty({index = Name({'_grammarName'}), expression = StringLiteral({self.name[#self.name][1]})})})
for ri = 1, #self.rules do
local ruleDef = self.rules[ri]
ruleDef.namespace = self.name
props[ri + 1] = SetProperty({index = ruleDef.name, expression = Rule.toLuaAst(ruleDef, context)})
end
local grammar = TableConstructor({properties = props})
return Set({isLocal = self.isLocal, names = Array({name2ast(self.name)}), expressions = Array({exp([[OMeta.Grammar(]], grammar, [[)]])})})
end
function Rule:toLuaAst(context)
context.locals = {}
for ai = 1, #self.arguments do
context.locals[self.arguments[ai][1]] = true
end
context = context:newScope({})
local body, res = toLuaAst(self.block, context)
context:declareLocals(body)
body:append(laststat([[return ]], res, [[]]))
local arity
if self.variableArguments then
arity = -1
self.arguments:append(Name({'...'}))
else
arity = #self.arguments
end
local index
if StringLiteral:isInstance(self.name) then
index = self.name
else
index = StringLiteral({self.name:toLuaSource()})
end
return exp([[OMeta.Rule {
    behavior = function(]], self.arguments:prepend(Name({'input'})), [[)
      ]], body, [[
    end;
    arity = ]], RealLiteral({arity}), [[,
    grammar = ]], name2ast(self.namespace), [[,
    name = ]], index, [[;
  }]])
end
function RuleStatement:toLuaAst(context)
return Set({isLocal = self.isLocal, names = Array({exp([[]], name2ast(self.namespace), [[.]], self.name, [[]])}), expressions = Array({Rule.toLuaAst(self, context)})})
end
function RuleExpression:toLuaAst(context)
error('standalone Rule Expression not allowed')
end
function Application:toLuaAst(context)
return self:toRuleApplication():toLuaAst(context)
end
function Choice:toLuaAst(context)
if #self.nodes ~= 1 or self.scope == true then
context.scope = true
end
return Application.toLuaAst(self, context)
end
function Sequence:toLuaAst(context)
local stats, result = Array({})
local scope = context.scope
if scope then
context = context:newScope({})
end
for e = 1, #self.nodes do
local first, last, node = e == 1, e == #self.nodes, self.nodes[e]
local body, res = toLuaAst(node, context)
stats:appendAll(body)
if not last or rawget(context.locals, '__result__') then
if Array:isInstance(res) then
if res[2] then
if Statement:isInstance(res[2]) then
stats:append(res[2])
elseif Invocation:isInstance(res[2]) then
stats:append(stat([[local _ = ]], res[2], [[]]))
end
end
if not BooleanLiteral:isInstance(res[1]) then
stats:append(stat([[if not (]], res[1], [[) then return false end]]))
elseif res[1][1] ~= true then
stats:append(laststat([[return false]]))
end
if last then
result = Array({res[1], Get({name = Name({'__result__'})})})
end
else
stats:append(stat([[if not (]], res, [[) then return false end]]))
if last then
result = Array({BooleanLiteral({true}), Get({name = Name({'__result__'})})})
end
end
else
result = res
end
end
if scope then
context:declareLocals(stats)
end
return stats, result
end
function Binding:toLuaAst(context)
local body, res = toLuaAst(self.expression, context)
local name = self.name
if name[1] == '^' then
name = Name({'__result__'})
end
body:append(stat([[__pass__, ]], name, [[ = ]], res, [[]]))
context.locals['__pass__'] = true
context.locals[name[1]] = true
return body, Array({exp([[__pass__]]), exp([[]], name, [[]])})
end
function HostStatement:toLuaAst(context)
return self.value, Array({BooleanLiteral({true}), nil})
end
function HostExpression:toLuaAst(context)
return Array({}), Array({BooleanLiteral({true}), self.value})
end
function HostPredicate:toLuaAst(context)
return Array({}), Array({self.value, nil})
end
local function toArgument(orig, context, generic)
if Choice:isInstance(orig) and #orig.nodes == 1 and #orig.nodes[1].nodes == 1 and not Binding:isInstance(orig.nodes[1].nodes[1]) then
orig = orig.nodes[1].nodes[1]
end
if Exactly:isInstance(orig) and Literal:isInstance(orig.expression) and not generic then
orig = orig.expression
end
if Application:isInstance(orig) and not Choice:isInstance(orig) then
orig = orig:toRuleApplication()
end
local trans
if type(orig) ~= 'table' then
print(orig)
trans = orig
elseif Literal:isInstance(orig) and not generic then
trans = orig
elseif HostExpression:isInstance(orig) and not generic then
trans = orig.value
elseif RuleApplication:isInstance(orig) and not orig.target and #orig.arguments == 0 then
trans = name2ast(orig.name, context)
else
local body, res = toLuaAst(orig, context)
if #body == 0 and Array:isInstance(res) and BooleanLiteral:isInstance(res[1]) and res[1][1] == true and Literal:isInstance(res[2]) and not generic then
trans = res[2]
else
body:append(laststat([[return ]], res, [[]]))
trans = exp([[function (input) ]], body, [[ end]])
end
end
return trans
end
function RuleApplication:toLuaAst(context)
local target = self.target and name2ast(self.target)
local ruleref = name2ast(self.name, context)
local arguments = Array({})
for ai = 1, #self.arguments do
arguments[ai] = toArgument(self.arguments[ai], context, self.generic)
end
local fname = Name({'apply' .. (target and 'Foreign' or '') .. (#arguments == 0 and '' or 'WithArgs')})
arguments:prepend(ruleref)
if target then
arguments:prepend(target)
end
return Array({}), exp([[input:]], fname, [[(]], arguments, [[)]])
end
return {toLuaAst = toLuaAst}
