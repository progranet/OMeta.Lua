local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local types = require('types')
local class = types.class
local Any, Array = types.Any, types.Array
local asc = require('abstractsyntax_commons')
local Literal, NilLiteral, BooleanLiteral, NumberLiteral, IntegerLiteral, RealLiteral, StringLiteral, Token, Name, Keyword, Special, Node, Statement, Expression, Control, Iterative, Invocation = asc.Literal, asc.NilLiteral, asc.BooleanLiteral, asc.NumberLiteral, asc.IntegerLiteral, asc.RealLiteral, asc.StringLiteral, asc.Token, asc.Name, asc.Keyword, asc.Special, asc.Node, asc.Statement, asc.Expression, asc.Control, asc.Iterative, asc.Invocation
local las = require('lua_abstractsyntax')
local Get, Set, Group, Block, Chunk, Do, While, Repeat, If, ElseIf, For, ForIn, Function, MethodStatement, FunctionStatement, FunctionExpression, Return, Break, LastStatement, Call, Send, BinaryOperation, UnaryOperation, GetProperty, VariableArguments, TableConstructor, SetProperty, Goto, Label = las.Get, las.Set, las.Group, las.Block, las.Chunk, las.Do, las.While, las.Repeat, las.If, las.ElseIf, las.For, las.ForIn, las.Function, las.MethodStatement, las.FunctionStatement, las.FunctionExpression, las.Return, las.Break, las.LastStatement, las.Call, las.Send, las.BinaryOperation, las.UnaryOperation, las.GetProperty, las.VariableArguments, las.TableConstructor, las.SetProperty, las.lua52.Goto, las.lua52.Label
local omas = require('ometa_abstractsyntax')
local Binding, Application, Choice, Sequence, Lookahead, ExactlyApp, TokenApp, StringApp, Lookahead, NotPredicate, AndPredicate, OptionalApp, ManyApp, ConsumedApp, RepeatApp, AnythingApp, HostNode, HostStatement, HostExpression, RuleApplication, Table, Key, Rule, RuleExpression, RuleStatement = omas.Binding, omas.Application, omas.Choice, omas.Sequence, omas.Lookahead, omas.ExactlyApp, omas.TokenApp, omas.StringApp, omas.Lookahead, omas.NotPredicate, omas.AndPredicate, omas.OptionalApp, omas.ManyApp, omas.ConsumedApp, omas.RepeatApp, omas.AnythingApp, omas.HostNode, omas.HostStatement, omas.HostExpression, omas.RuleApplication, omas.Table, omas.Key, omas.Rule, omas.RuleExpression, omas.RuleStatement
local OMeta = require('ometa')
local Grammar = require('ometa_lua_grammar').OMetaInLuaHeterogenousGrammar
local toLuaAst
local luaContext = OMeta.with(Grammar)
local function exp(...)
return toLuaAst(luaContext:interparse(Grammar.exp, ...))
end
local function stat(...)
return toLuaAst(luaContext:interparse(Grammar.stat, ...))
end
local function laststat(...)
return toLuaAst(luaContext:interparse(Grammar.laststat, ...))
end
local LocalKind = {variable = 1, temp = 2, parameter = 3, label = 4}
local ActionKind = {none = 0, _break = 1, _return = 2, _goto = 3}
local Context = class({name = 'Context', super = {Any}, new = function(self, props)
props = props or {}
props.parentContext = self
props._labels = {num = 0}
setmetatable(props, {__index = self})
return props
end, openScope = function(self)
assert(not rawget(self, "locals"), 'Context already opened')
local parentLocals, mt = self.parentContext.locals, {}
if parentLocals then
mt.__index = parentLocals
end
self.locals = setmetatable({}, mt)
self.parentLocals = parentLocals
return self
end, closeScope = function(self, result)
local localnames, decs, num = Array({}), Array({}), 0
local leak = result:getValue()
if leak then
local hoisted = self:hoistAll(leak)
end
for name, desc in pairs(self.locals) do
local kind, deps = desc.kind, Array({})
for i = 1, #result.code do
deps:appendAll(result.code[i]:collectNodes(kind == LocalKind.label and Goto or Get, function(node)
return node.name[1] == name
end))
end
desc.deps = #deps
if #deps ~= 0 and (kind == LocalKind.variable or kind == LocalKind.temp) then
if desc.value then
decs:append(stat([[local ]], desc.name, [[ = ]], desc.value, [[]]))
else
num = num + 1
localnames[num] = desc.name
end
end
end
if num ~= 0 then
decs:prepend(stat([[local ]], localnames, [[]]))
end
return decs
end, openProtected = function(self, forLabel)
if not self._labels[forLabel] then
self._labels[forLabel] = true
self._labels[num] = self._labels[num] + 1
end
end, closeProtected = function(self, forLabel)
assert(self._labels[forLabel], 'Label ' .. forLabel .. ' not defined')
self._labels[forLabel] = nil
self._labels[num] = self._labels[num] - 1
end, hoist = function(self, variableName)
end, hoistAll = function(self, leak)
local names = Array({})
for name, desc in pairs(self.locals) do
local kind = desc.kind
if kind == LocalKind.variable or kind == LocalKind.temp then
if Node:isInstance(leak) then
local deps = #leak:collectNodes(Get, function(node)
return node.name[1] == name
end)
if deps ~= 0 then
self.parentLocals[name] = desc
self.locals[name] = nil
names[#names + 1] = name
end
end
end
end
return names
end, declare = function(self, node, name, kind, value)
kind = kind or LocalKind.temp
if node then
name = node._id .. name
end
local var = self.locals[name]
if var then
if var.kind ~= kind then
error('variable kind declaration mismatch: ' .. name)
end
if value then
if var.value ~= value then
error('variable redefinition: ' .. name .. ' (' .. tostring(var.value) .. ' ~= ' .. tostring(value) .. ')')
end
var.value = value
end
else
self.locals[name] = {name = Name({name}), kind = kind, value = value}
end
return Name({name})
end, isUsed = function(self, name)
local var = rawget(self.locals, name[1])
return var and var.deps ~= nil and var.deps ~= 0
end})
local Result = class({name = 'Result', super = {Any}, getValue = function(self)
return self.value or (self.optional and BooleanLiteral({true})) or (self.context.variable and exp([[]], self.context.variable, [[]])) or nil
end})
function Literal:toLuaAst()
return self
end
function Node:toLuaAst(context)
local nodetype, clone, newcontext = getmetatable(self).__index, {}, context:new({parentNode = self})
for k, v in pairs(self) do
if Any:isInstance(v) then
clone[k] = v:toLuaAst(newcontext)
else
clone[k] = v
end
end
return nodetype(clone)
end
function Array:toLuaAst(context)
local clone = Array({})
for k = 1, #self do
local v = self[k]
if Any:isInstance(v) then
clone[k] = v:toLuaAst(context)
else
clone[k] = v
end
end
return clone
end
function Rule:toLuaAst(context, name)
local context = context:new():openScope()
for ai = 1, #self.arguments do
context:declare(nil, self.arguments[ai][1], LocalKind.parameter)
end
context.onFail = ActionKind._return
local result = self.body:toLuaAst(context)
result.code:append(laststat([[return ]], result:getValue(), [[]]))
result.value = NilLiteral({})
result.code:prependAll(context:closeScope(result))
local trans = exp([[{
    behavior = function(]], self.arguments:prepend(Name({'input'})), [[)
      ]], result.code, [[
    end;
    arity = ]], RealLiteral({#self.arguments - 1}), [[,
    name = ]], StringLiteral({name[1]}), [[;
    count = 0,
    hits = 0,
    cache = 0;
  }]])
local partial = context.partials[name[1]]
if partial then
partial.refs[#partial.refs + 1] = trans
end
return trans
end
function RuleStatement:toLuaAst(context)
return stat([[]], self.name, [[ = ]], Rule.toLuaAst(self, context, self.name), [[]])
end
function RuleExpression:toLuaAst(context)
return Rule.toLuaAst(self, context, context.parentNode.index)
end
function Choice:toLuaAst(context)
local newcontext = context:new():openScope()
local passlabel = newcontext:declare(self, 'pass', LocalKind.label)
newcontext.passlabel = passlabel
newcontext.onFail = ActionKind.none
local headvar = {}
local patternlen, hgen, currlen = {}, 0
for i = 1, #self.nodes do
local orig = self.nodes[i]
local first = #orig.nodes == 1 and orig.nodes[1]
local len = first and (ExactlyApp:isInstance(first) and 0 or StringApp:isInstance(first) and #first.expression[1])
if len ~= currlen or len == false then
hgen = hgen + #orig.nodes
currlen = len
end
if len and headvar[len] == nil then
headvar[len] = newcontext:declare(self, 'head' .. tostring(len))
end
patternlen[i] = len
end
local single, simple, tempvar = #self.nodes == 1, hgen == 1
if not newcontext.variable then
tempvar = newcontext:declare(self, 'val')
newcontext.variable = tempvar
end
local genstring = {}
newcontext.undostate = newcontext:declare(self, 'undo')
local code, value, optional = Array({stat([[]], newcontext.undostate, [[ = input.stream]])})
local i, firstScope = 1
repeat
local first, last = i == 1, i == #self.nodes
local currlen = patternlen[i]
if currlen then
if not genstring[currlen] then
genstring[currlen] = true
if currlen == 0 then
code:append(stat([[]], headvar[0], [[ = input.stream:head()]]))
else
code:append(stat([[]], headvar[currlen], [[ = input.stream.lst:sub(input.stream._index, input.stream._index + ]], RealLiteral({currlen - 1}), [[)]]))
end
end
local condition
repeat
local subcondition = exp([[]], headvar[currlen], [[ == ]], self.nodes[i].nodes[1].expression, [[]])
condition = condition and exp([[]], condition, [[ or ]], subcondition, [[]]) or subcondition
i = i + 1
until i > #self.nodes or patternlen[i] ~= currlen
local success = Array({stat([[]], newcontext.variable, [[ = ]], currlen == 0 and exp([[input:next()]]) or exp([[input:collect(]], RealLiteral({currlen}), [[):concat()]]), [[]]), stat([[goto ]], passlabel, [[]])})
code:append(stat([[
          if ]], condition, [[ then 
            ]], success, [[
          end
        ]]))
else
local faillabel = newcontext:declare(self, 'fail' .. tostring(i), LocalKind.label)
local innercontext = newcontext:new({faillabel = faillabel, rollback = #self.nodes[i].nodes ~= 1})
newcontext.onFail = ActionKind._goto
newcontext.onFailGoto = faillabel
local result = self.nodes[i]:toLuaAst(innercontext)
if result.optional then
optional = true
end
code:appendAll(result.code)
if result.optional then
code:append(stat([[goto ]], passlabel, [[]]))
else
code:append(stat([[if ]], newcontext.variable, [[ ~= nil then goto ]], passlabel, [[ end]]))
end
code:append(stat([[::]], faillabel, [[::]]))
if innercontext.rollback then
code:append(stat([[input.stream = ]], newcontext.undostate, [[]]))
end
if simple then
value = result:getValue()
end
i = i + 1
end
until i > #self.nodes
local result = Result({context = newcontext, code = code, value = value, optional = optional})
result.code:prependAll(newcontext:closeScope(result))
if context.onFail == ActionKind._break then
result.code:append(laststat([[break]]))
elseif context.onFail == ActionKind._return then
result.code:append(laststat([[return]]))
elseif context.onFail == ActionKind._goto then
result.code:append(stat([[goto ]], context.onFailGoto, [[]]))
end
result.code = Array({stat([[do ]], result.code, [[ end]])})
result.code:append(stat([[::]], passlabel, [[::]]))
return result
end
function Sequence:toLuaAst(context)
local code, value, optional = Array({})
for i = 1, #self.nodes do
local first, last = i == 1, i == #self.nodes
local newcontext = context:new()
if not first then
newcontext.undostate = newcontext:declare(self, 'undo' .. tostring(i))
code:append(stat([[]], newcontext.undostate, [[ = input.stream]]))
end
newcontext.variable = last and context.variable or false
local result = self.nodes[i]:toLuaAst(newcontext)
if not last then
local _value = result:getValue()
if result.optional then
if Literal:isInstance(_value) or Get:isInstance(_value) or GetProperty:isInstance(_value) then
elseif not Invocation:isInstance(_value) or BinaryOperation:isInstance(_value) or UnaryOperation:isInstance(_value) then
result.code:append(stat([[do local _ = ]], _value, [[ end]]))
else
result.code:append(stat([[]], _value, [[]]))
end
else
result.code:append(stat([[if ]], _value, [[ == nil then goto ]], context.faillabel, [[ end]]))
end
else
value = result:getValue()
optional = result.optional
end
code:appendAll(result.code)
end
return Result({context = context, code = code, value = value, optional = optional})
end
function Binding:toLuaAst(context)
local innercontext = context:new({variable = self.name})
local result = self.expression:toLuaAst(innercontext)
context:declare(nil, self.name[1])
if context.variable then
result.code:append(stat([[]], context.variable, [[ = ]], self.name, [[]]))
end
return result
end
function Application:toLuaAst(context)
return self:toRuleApplication():toLuaAst(context)
end
function NotPredicate:toLuaAst(context)
local innercontext = context:new({variable = context.variable or context:declare(self, 'val')})
local result = self.expression:toLuaAst(innercontext)
result.code:append(stat([[input.stream = ]], context.undostate, [[]]))
if context.variable then
result.code:append(stat([[]], context.variable, [[ = ]], innercontext.variable, [[ == nil or nil]]))
else
result.value = exp([[(]], innercontext.variable, [[ == nil or nil)]])
end
return result
end
function AndPredicate:toLuaAst(context)
local innercontext = context:new({variable = context.variable or context:declare(self, 'val')})
local result = self.expression:toLuaAst(innercontext)
result.code:append(stat([[input.stream = ]], context.undostate, [[]]))
return result
end
function ConsumedApp:toLuaAst(context)
local posvar = context:declare(self, 'idx')
local innercontext = context:new({variable = false})
innercontext:openScope()
local innerresult = self.expression:toLuaAst(innercontext)
local code, value = Array({stat([[]], posvar, [[ = input.stream._index]])})
code:appendAll(innercontext:closeScope(innerresult))
code:appendAll(innerresult.code)
local _value = exp([[input.stream.lst:sub(]], posvar, [[, input.stream._index - 1, true)]])
if context.variable then
if innerresult.optional then
code:append(stat([[]], context.variable, [[ = ]], _value, [[]]))
else
code:append(stat([[if ]], innerresult:getValue(), [[ ~= nil then ]], context.variable, [[ = ]], _value, [[ end]]))
end
else
value = innerresult.optional and _value or exp([[(]], innerresult:getValue(), [[ ~= nil and ]], _value, [[ or nil)]])
end
return Result({context = context, code = code, value = value})
end
function OptionalApp:toLuaAst(context)
context.onFail = ActionKind.none
local result = self.expression:toLuaAst(context)
result.optional = true
return result
end
function ManyApp:toLuaAst(context)
local innercontext = context:new():openScope()
local code = Array({})
local optional = not self.minimum or self.minimum[1] == 0
local lenvar, stepvar
if not optional or context.variable then
lenvar = context:declare(self, 'len', LocalKind.temp, RealLiteral({0}))
if context.variable then
code:append(stat([[]], context.variable, [[ = Array {}]]))
stepvar = innercontext:declare(self, 'val')
innercontext.variable = stepvar
end
end
innercontext.onFail = ActionKind._break
local innerresult = self.expression:toLuaAst(innercontext)
if #innerresult.code == 0 and optional and not context.variable then
code:append(stat([[repeat until ]], innerresult:getValue(), [[ == nil]]))
else
if not Choice:isInstance(self.expression) and (optional or context.variable) then
innerresult.code:append(stat([[if ]], stepvar or innerresult:getValue(), [[ == nil then break end]]))
end
if not optional or context.variable then
innerresult.code:append(stat([[]], lenvar, [[ = ]], lenvar, [[ + 1]]))
if context.variable then
innerresult.code:append(stat([[]], context.variable, [[[]], lenvar, [[] = ]], stepvar, [[]]))
end
end
innerresult.code:prependAll(innercontext:closeScope(innerresult))
code:append(stat([[while ]], not optional and not context.variable and exp([[]], innerresult:getValue(), [[ ~= nil]]) or BooleanLiteral({true}), [[ do ]], innerresult.code, [[ end]]))
end
local result = Result({context = context, code = code, optional = optional})
if not optional then
if context.variable then
code:append(stat([[
        if ]], lenvar, [[ < ]], self.minimum, [[ then 
          ]], context.variable, [[ = nil
        end
      ]]))
else
result.value = exp([[(]], lenvar, [[ >= ]], self.minimum, [[ or nil)]])
end
end
return result
end
function RepeatApp:toLuaAst(context)
error()
local timescontext = context:openScope({})
local stats = self.times:toLuaAst(timescontext)
stats.closeScope = true
stats = timescontext:close(stats)
local body, fail = Array({}), Array({})
local newcontext = context:openScope({})
local tempvar
local stepvar
if context.variable then
stats:append(stat([[]], context.variable, [[ = Array {}]]))
stepvar = newcontext:declare(self, 'val')
body:append(stat([[local ]], stepvar, [[]]))
newcontext.variable = stepvar
fail:append(stat([[]], context.variable, [[ = nil]]))
context.result = exp([[]], context.variable, [[]])
else
tempvar = newcontext:declare(self, 'pass')
stats:append(stat([[]], tempvar, [[ = true]]))
fail:append(stat([[]], tempvar, [[ = false]]))
context.result = exp([[(]], tempvar, [[ or nil)]])
end
fail:append(laststat([[break]]))
body:appendAll(self.expression:toLuaAst(newcontext))
body:append(stat([[if ]], stepvar or newcontext.result, [[ == nil then ]], fail, [[ end]]))
local lenvar = newcontext:declare(self, 'len')
if context.variable then
body:append(stat([[]], context.variable, [[[]], lenvar, [[] = ]], stepvar, [[]]))
end
stats:append(stat([[for ]], lenvar, [[ = 1, ]], timescontext.result, [[ do ]], body, [[ end]]))
stats = newcontext:close(stats)
return stats
end
function AnythingApp:toLuaAst(context)
local result = Result({context = context})
if context.variable then
result.code = Array({stat([[]], context.variable, [[ = input:next()]])})
else
result.code = Array({})
result.value = exp([[(input:next())]])
end
return result
end
function HostStatement:toLuaAst(context)
local result = {context = context, code = self.value, optional = true}
return result
end
function HostExpression:toLuaAst(context)
local result = Result({context = context})
if context.variable then
result.code = Array({stat([[]], context.variable, [[ = ]], self.value, [[]])})
else
result.code = Array({})
result.value = exp([[(]], self.value, [[)]])
end
return result
end
local function name2ast(name, context)
local ast = Get({name = name[1]})
if context and #name == 1 then
if context.locals[name[1][1]] then
return ast
end
local l1 = name[1][1]:sub(1, 1)
if l1 >= 'A' and l1 <= 'Z' then
return ast
end
return exp([[input.grammar.]], name[1], [[]])
end
for i = 2, #name do
ast = GetProperty({context = ast, index = name[i]})
end
return ast
end
local function toFn(orig, context)
if Choice:isInstance(orig) and #orig.nodes == 1 and #orig.nodes[1].nodes == 1 then
orig = orig.nodes[1].nodes[1]
end
if Application:isInstance(orig) then
orig = orig:toRuleApplication()
end
local trans
if Literal:isInstance(orig) then
trans = orig
elseif HostExpression:isInstance(orig) then
trans = orig.value
elseif RuleApplication:isInstance(orig) and not orig.target and #orig.arguments == 0 then
trans = name2ast(orig.name, context)
elseif RuleApplication:isInstance(orig) and not orig.target and #orig.arguments == 1 and Literal:isInstance(orig.arguments[1]) and #orig.name == 1 and context.partials[orig.name[1][1]] then
trans = exp([[]], name2ast(orig.name, context), [[[]], orig.arguments[1], ']')
context.partials[orig.name[1][1]].vals[orig.arguments[1][1]] = true
else
local newcontext = context:new({variable = false})
newcontext.onFail = ActionKind._return
local result = orig:toLuaAst(newcontext)
if #result.code == 0 and Literal:isInstance(result:getValue()) then
trans = result:getValue()
else
result.code:append(laststat([[return ]], result:getValue(), [[]]))
trans = exp([[function (input) ]], result.code, [[ end]])
end
end
return trans
end
function RuleApplication:toLuaAst(context)
local target = self.target and name2ast(self.target)
local ruleref = name2ast(self.name, context)
local arguments = Array({})
if not target and #self.arguments == 1 and Literal:isInstance(self.arguments[1]) and #self.name == 1 and context.partials[self.name[1][1]] then
ruleref = exp([[]], ruleref, [[[]], self.arguments[1], ']')
context.partials[self.name[1][1]].vals[self.arguments[1][1]] = true
else
for ai = 1, #self.arguments do
arguments[ai] = toFn(self.arguments[ai], context)
end
end
local fname = 'apply' .. (target and 'Foreign' or '') .. (#arguments == 0 and '' or 'WithArgs')
arguments:prepend(ruleref)
if target then
arguments:prepend(target)
end
local result = Result({context = context})
if context.variable then
result.code = Array({stat([[]], context.variable, [[ = input:]], Name({fname}), [[(]], arguments, [[)]])})
else
result.code = Array({})
result.value = exp([[input:]], Name({fname}), [[(]], arguments, [[)]])
end
return result
end
function Table:toLuaAst(context)
error()
local undostate = Name({self._id .. 'undo'})
local dostate = Name({self._id .. 'do'})
local tablevar = Name({self._id .. 'tab'})
local resvar = Name({self._id .. 'val'})
local newcontext = context:new({})
local stats = Array({stat([[local ]], undostate, [[ = input.stream]]), stat([[local ]], tablevar, [[, ]], resvar, [[ = input:next()]]), stat([[local ]], dostate, [[ = input.stream]]), stat([[input.stream = streams.ArrayInputStream:new(]], tablevar, [[)]])})
local inner = Array({stat([[]], resvar, [[ = ]], tablevar, [[]])})
if #self.map ~= 0 then
local map = Choice({nodes = Array({Sequence({locals = Array({}), nodes = self.map})})})
inner = map:toLuaAst(newcontext):append(stat([[if ]], newcontext.result, [[ ~= nil then ]], inner, [[ end]]))
end
inner = Array({stat([[if input:next() == nil then ]], inner, [[ end]])})
if self.array then
local newinner = self.array:toLuaAst(newcontext)
newinner:append(stat([[if ]], newcontext.result, [[ ~= nil then ]], inner, [[ end]]))
inner = newinner
end
stats:appendAll(inner)
local success = Array({stat([[input.stream = ]], dostate, [[]])})
if context.variable then
success:append(stat([[]], context.variable, [[ = ]], resvar, [[]]))
else
context.result = exp([[]], resvar, [[]])
end
stats:append(stat([[if ]], resvar, [[ == nil then input.stream = ]], undostate, [[ else ]], success, [[ end]]))
return stats
end
function Key:toLuaAst(context)
local stats = Array({stat([[input.stream = input.stream:property(]], StringLiteral({self.name[1]}), [[)]])})
stats:appendAll(self.expression:toLuaAst(context))
return stats
end
toLuaAst = function(tree, partials)
partials = partials or {}
for pi = 1, #partials do
partials[partials[pi]] = {refs = {}, vals = {}}
partials[pi] = nil
end
local context = Context({partials = partials})
local ast = tree:toLuaAst(context)
for name, partial in pairs(partials) do
for ri = 1, #partial.refs do
local ruleAst = partial.refs[ri]
for val in pairs(partial.vals) do
local argName = ruleAst.properties[1].expression.arguments[2]
local body = string.interpolate([[local ]], argName, [[ = ]], StringLiteral({val}), [[]])
body = body:appendAll(ruleAst.properties[1].expression.block.statements)
ruleAst.properties:append(SetProperty({index = StringLiteral({val}), expression = exp([[{
            behavior = function(input) ]], body, [[ end;
            arity = 0,
            name = ]], StringLiteral({name .. '[' .. val .. ']'}), [[;
            count = 0,
            hits = 0,
            cache = 0;
          }]])}))
end
end
end
return ast
end
return {toLuaAst = toLuaAst}
