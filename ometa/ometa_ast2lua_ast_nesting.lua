local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local Types = require('types')
local class = Types.class
local Any, Array = Types.Any, Types.Array
local asc = require('abstractsyntax_commons')
local Literal, NilLiteral, BooleanLiteral, NumberLiteral, IntegerLiteral, RealLiteral, StringLiteral, Name, Keyword, Special, Node, Statement, Expression, Control, Iterative, Invocation = asc.Literal, asc.NilLiteral, asc.BooleanLiteral, asc.NumberLiteral, asc.IntegerLiteral, asc.RealLiteral, asc.StringLiteral, asc.Name, asc.Keyword, asc.Special, asc.Node, asc.Statement, asc.Expression, asc.Control, asc.Iterative, asc.Invocation
local las = require('lua_abstractsyntax')
local Get, Set, Group, Block, Chunk, Do, While, Repeat, If, ElseIf, For, ForIn, Function, MethodStatement, FunctionStatement, FunctionExpression, Return, Break, LastStatement, Call, Send, BinaryOperation, UnaryOperation, GetProperty, VariableArguments, TableConstructor, SetProperty, Goto, Label = las.Get, las.Set, las.Group, las.Block, las.Chunk, las.Do, las.While, las.Repeat, las.If, las.ElseIf, las.For, las.ForIn, las.Function, las.MethodStatement, las.FunctionStatement, las.FunctionExpression, las.Return, las.Break, las.LastStatement, las.Call, las.Send, las.BinaryOperation, las.UnaryOperation, las.GetProperty, las.VariableArguments, las.TableConstructor, las.SetProperty, las.lua52.Goto, las.lua52.Label
local omas = require('ometa_abstractsyntax')
local Binding, Application, Choice, Sequence, Lookahead, Exactly, Token, Subsequence, NotPredicate, AndPredicate, Optional, Many, Consumed, Loop, Anything, HostNode, HostPredicate, HostStatement, HostExpression, RuleApplication, Object, Key, Rule, RuleExpression, RuleStatement, Grammar, GrammarExpression, GrammarStatement = omas.Binding, omas.Application, omas.Choice, omas.Sequence, omas.Lookahead, omas.Exactly, omas.Token, omas.Subsequence, omas.NotPredicate, omas.AndPredicate, omas.Optional, omas.Many, omas.Consumed, omas.Loop, omas.Anything, omas.HostNode, omas.HostPredicate, omas.HostStatement, omas.HostExpression, omas.RuleApplication, omas.Object, omas.Key, omas.Rule, omas.RuleExpression, omas.RuleStatement, omas.Grammar, omas.GrammarExpression, omas.GrammarStatement
local toLuaAst
local rno = 0
local Grammar = require('ometa_lua_grammar').OMetaInLuaMixedGrammar
local function exp(...)
local ast = Grammar.exp:matchMixed(...)
return toLuaAst(ast)
end
local function stat(...)
local ast = Grammar.stat:matchMixed(...)
return toLuaAst(ast)
end
local function laststat(...)
local ast = Grammar.laststat:matchMixed(...)
return toLuaAst(ast)
end
local Context
Context = class({name = 'Context', super = {Any}, inherit = function (self, props)
props = setmetatable(props or {}, {__index = self})
return props
end, new = function (self, props)
props = Context(props or {})
if not props.locals then
props.locals = self.locals
end
props.partials = self.partials
return props
end})
function Literal:toLuaAst()
return self
end
function Node:toLuaAst(context)
local nodetype, clone = getmetatable(self).__index, {}
for k, v in pairs(self) do
if type(k) == 'string' and k:find('^%l') then
if Array:isInstance(v) then
clone[k] = Array({})
for i = 1, #v do
clone[k][i] = v[i]:toLuaAst(context:new({parent = self, name = k, index = i}))
end
else
clone[k] = v:toLuaAst(context:new({parent = self, name = k}))
end
else
clone[k] = v
end
end
return nodetype(clone)
end
function Rule:toLuaAst(context, name)
context.locals = {}
for ai = 1, #self.arguments do
context.locals[self.arguments[ai][1]] = true
end
local body = self.block:toLuaAst(context)
body:append(laststat([[return ]], context.result, [[]]))
local arity
if self.variableArguments[1] then
arity = -1
self.arguments:append(Name({'...'}))
else
arity = #self.arguments
end
local trans = exp([[OMeta.Rule {
    behavior = function(]], self.arguments:prepend(Name({'input'})), [[)
      ]], body, [[
    end;
    arity = ]], RealLiteral({arity}), [[,
    name = ]], StringLiteral({name[1]}), [[;
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
return Rule.toLuaAst(self, context, context.parent.index)
end
function Application:toLuaAst(context)
return self:toRuleApplication():toLuaAst(context)
end
function Choice:toLuaAst(context)
rno = rno + 1
local var = '_or' .. tostring(rno)
local tempvar
local undostate = Name({var .. 'undo'})
local headvar = Name({var .. 'head0'})
context.undostate = undostate
context.undoused = false
local patternlen, hgen, clen = {}, 0
for i = 1, #self.nodes do
local orig = self.nodes[i]
local first = #orig.nodes == 1 and orig.nodes[1]
local len = first and (Exactly:isInstance(first) and 0 or Subsequence:isInstance(first) and #first.expression[1])
if len ~= clen or len == false then
hgen = hgen + #orig.nodes
clen = len
end
patternlen[i] = len
end
local stats = Array({})
if not context.variable and hgen ~= 1 then
tempvar = Name({var .. 'val'})
stats:append(stat([[local ]], tempvar, [[]]))
context.result = exp([[]], tempvar, [[]])
context.variable = tempvar
end
local genstring = {}
local expgen
expgen = function (i)
local currpatternlen = patternlen[i]
if currpatternlen then
local curr = Array({})
if not genstring[currpatternlen] then
genstring[currpatternlen] = true
if currpatternlen == 0 then
curr:append(stat([[local ]], headvar, [[ = input.stream:head()]]))
else
curr:append(stat([[local ]], Name({string.interpolate([[]], var, [[head]], currpatternlen, [[]])}), [[ = input.stream._source:sub(input.stream._index, input.stream._index + ]], RealLiteral({currpatternlen - 1}), [[)]]))
end
end
local j, condition = i
repeat
local subcondition
if currpatternlen == 0 then
subcondition = exp([[]], headvar, [[ == ]], self.nodes[j].nodes[1].expression, [[]])
else
subcondition = exp([[]], Name({string.interpolate([[]], var, [[head]], currpatternlen, [[]])}), [[ == ]], self.nodes[j].nodes[1].expression, [[]])
end
condition = condition and exp([[]], condition, [[ or ]], subcondition, [[]]) or subcondition
j = j + 1
until j > #self.nodes or patternlen[j] ~= currpatternlen
local fail = Array({})
if j <= #self.nodes then
fail:appendAll(expgen(j))
end
if context.variable then
curr:append(stat([[
          if ]], condition, [[ then 
            ]], context.variable, [[ = ]], currpatternlen == 0 and exp([[input:next()]]) or exp([[input:collect(]], RealLiteral({currpatternlen}), [[):concat()]]), [[
          else 
            ]], fail, [[ 
          end
        ]]))
else
context.result = currpatternlen == 0 and exp([[((]], condition, [[) and input:next() or nil)]]) or exp([[((]], condition, [[) and input:collect(]], RealLiteral({currpatternlen}), [[):concat() or nil)]])
end
return curr
else
local curr = self.nodes[i]:toLuaAst(context)
local fail = Array({})
if #self.nodes[i].nodes ~= 1 then
fail:append(stat([[input.stream = ]], undostate, [[]]))
context.undoused = true
end
if i ~= #self.nodes then
fail:appendAll(expgen(i + 1))
end
if #fail ~= 0 then
curr:append(stat([[if ]], context.variable or context.result, [[ == nil then ]], fail, [[ end]]))
end
return curr
end
end
stats:appendAll(expgen(1))
if context.undoused then
stats:prepend(stat([[local ]], undostate, [[ = input.stream]]))
end
return stats
end
print(Choice.toLuaAst)
function Sequence:toLuaAst(context)
rno = rno + 1
local var = '_and' .. tostring(rno)
local locals = setmetatable({}, {__index = context.locals})
local expgen
expgen = function (i)
local first, last = i == 1, i == #self.nodes
local newcontext = context:new({locals = locals})
local undostate
if first then
newcontext.undostate = context.undostate
else
undostate = Name({var .. 'undo' .. tostring(i)})
newcontext.undostate = undostate
newcontext.undoused = false
end
local stats = Array({})
if last then
newcontext.variable = context.variable
end
local trans = self.nodes[i]:toLuaAst(newcontext)
if newcontext.undoused then
if first then
context.undoused = true
else
stats:append(stat([[local ]], undostate, [[ = input.stream]]))
end
end
stats:appendAll(trans)
if not last then
if newcontext.optional then
stats:append(stat([[local _ = ]], newcontext.result, [[]]))
stats:appendAll(expgen(i + 1))
else
stats:append(stat([[if ]], newcontext.result, [[ ~= nil then ]], expgen(i + 1), [[ end]]))
end
else
if newcontext.optional then
if newcontext.safe then
if context.variable then
else
context.result = newcontext.result
end
else
if context.variable then
stats:append(stat([[if ]], context.variable, [[ == nil then ]], context.variable, [[ = true end]]))
else
context.result = exp([[]], newcontext.result, [[ ~= nil and ]], newcontext.result, [[ or true]])
end
end
else
if context.variable then
else
context.result = newcontext.result
end
end
end
return stats
end
local stats = expgen(1)
local localnames, num = Array({}), 0
for name in pairs(locals) do
num = num + 1
localnames[num] = Name({name})
end
if num ~= 0 then
stats = stats:prepend(stat([[local ]], localnames, [[]]))
end
return stats
end
function Binding:toLuaAst(context)
local outer = context.variable
context.variable = self.name
local stats = self.expression:toLuaAst(context)
context.locals[self.name[1]] = true
if outer then
context.variable = outer
stats:append(stat([[]], outer, [[ = ]], self.name, [[]]))
end
context.result = exp([[]], context.variable, [[]])
return stats
end
function NotPredicate:toLuaAst(context)
rno = rno + 1
local var = '_not' .. tostring(rno)
local tempvar
local parentvar = context.variable
context.variable = false
local stats = Array({})
stats:appendAll(self.expression:toLuaAst(context))
if parentvar then
context.variable = parentvar
else
tempvar = Name({var .. 'val'})
context.variable = tempvar
stats:append(stat([[local ]], tempvar, [[]]))
end
stats:append(stat([[]], context.variable, [[ = ]], context.result, [[ == nil or nil]]))
context.result = exp([[]], context.variable, [[]])
stats:append(stat([[input.stream = ]], context.undostate, [[]]))
context.undoused = true
return stats
end
function AndPredicate:toLuaAst(context)
rno = rno + 1
local var = '_ahead' .. tostring(rno)
local tempvar
local parentvar = context.variable
context.variable = false
local stats = Array({})
stats:appendAll(self.expression:toLuaAst(context))
if parentvar then
context.variable = parentvar
else
tempvar = Name({var .. 'val'})
context.variable = tempvar
stats:append(stat([[local ]], tempvar, [[]]))
end
stats:append(stat([[]], context.variable, [[ = ]], context.result, [[]]))
context.result = exp([[]], context.variable, [[]])
stats:append(stat([[input.stream = ]], context.undostate, [[]]))
context.undoused = true
return stats
end
function Consumed:toLuaAst(context)
rno = rno + 1
local var = '_consumed' .. tostring(rno)
local posvar = Name({var .. 'idx'})
local stats = Array({stat([[local ]], posvar, [[ = input.stream._index]])})
local newcontext = context:new({})
stats:appendAll(self.expression:toLuaAst(newcontext))
if context.variable then
stats:append(stat([[
      if ]], newcontext.result, [[ ~= nil then
        ]], context.variable, [[ = input.stream._source:sub(]], posvar, [[, input.stream._index - 1, true)
      end
    ]]))
else
context.result = exp([[(]], newcontext.result, [[ ~= nil and input.stream._source:sub(]], posvar, [[, input.stream._index - 1, true) or nil)]])
end
return stats
end
function Optional:toLuaAst(context)
local stats = self.expression:toLuaAst(context)
context.optional = true
return stats
end
function Many:toLuaAst(context)
rno = rno + 1
local var = '_many' .. tostring(rno)
local lenvar
local stepvar
local newcontext = context:new({})
local stats, body = Array({}), Array({})
local optional = not self.minimum or self.minimum[1] == 0
if not optional or context.variable then
lenvar = Name({var .. 'len'})
stats:append(stat([[local ]], lenvar, [[ = 0]]))
if context.variable then
stats:append(stat([[]], context.variable, [[ = Array {}]]))
stepvar = Name({var .. 'val'})
body:append(stat([[local ]], stepvar, [[]]))
newcontext.variable = stepvar
end
end
body:appendAll(self.expression:toLuaAst(newcontext))
if #body == 0 and optional and not context.variable then
stats:append(stat([[repeat until ]], newcontext.result, [[ == nil]]))
else
body:append(stat([[if ]], stepvar or newcontext.result, [[ == nil then break end]]))
if not optional or context.variable then
body:append(stat([[]], lenvar, [[ = ]], lenvar, [[ + 1]]))
if context.variable then
body:append(stat([[]], context.variable, [[[]], lenvar, [[] = ]], stepvar, [[]]))
end
end
stats:append(stat([[while true do ]], body, [[ end]]))
end
if not optional then
local fail = Array({})
if context.variable then
fail:append(stat([[]], context.variable, [[ = nil]]))
else
context.result = exp([[(]], lenvar, [[ >= ]], self.minimum, [[ or nil)]])
end
if #fail ~= 0 then
stats:append(stat([[
        if ]], lenvar, [[ < ]], self.minimum, [[ then 
          ]], fail, [[
        end
      ]]))
end
else
if not context.variable then
context.result = exp([[true]])
end
context.optional = true
context.safe = true
end
return stats
end
function Loop:toLuaAst(context)
rno = rno + 1
local var = '_rep' .. tostring(rno)
local lenvar = Name({var .. 'len'})
local tempvar
local stepvar
local timescontext = context:new({})
local stats = self.times:toLuaAst(timescontext)
local body, fail = Array({}), Array({})
local newcontext = context:new({})
if context.variable then
stats:append(stat([[]], context.variable, [[ = Array {}]]))
stepvar = Name({var .. 'val'})
body:append(stat([[local ]], stepvar, [[]]))
newcontext.variable = stepvar
fail:append(stat([[]], context.variable, [[ = nil]]))
else
tempvar = Name({var .. 'pass'})
stats:append(stat([[local ]], tempvar, [[ = true]]))
fail:append(stat([[]], tempvar, [[ = false]]))
context.result = exp([[(]], tempvar, [[ or nil)]])
end
fail:append(laststat([[break]]))
body:appendAll(self.expression:toLuaAst(newcontext))
body:append(stat([[if ]], stepvar or newcontext.result, [[ == nil then ]], fail, [[ end]]))
if context.variable then
body:append(stat([[]], context.variable, [[[]], lenvar, [[] = ]], stepvar, [[]]))
end
stats:append(stat([[for ]], lenvar, [[ = 1, ]], timescontext.result, [[ do ]], body, [[ end]]))
return stats
end
function Anything:toLuaAst(context)
local stats = Array({})
if context.variable then
stats:append(stat([[]], context.variable, [[ = input:next()]]))
else
context.result = exp([[(input:next())]])
end
return stats
end
function HostStatement:toLuaAst(context)
context.result = exp([[true]])
return self.value
end
function HostExpression:toLuaAst(context)
local stats = Array({})
if context.variable then
stats:append(stat([[]], context.variable, [[ = ]], self.value, [[]]))
else
context.result = exp([[(]], self.value, [[)]])
end
return stats
end
function HostPredicate:toLuaAst(context)
local stats = Array({})
if context.variable then
stats:append(stat([[]], context.variable, [[ = ]], self.value, [[ or nil]]))
else
context.result = exp([[(]], self.value, [[ or nil)]])
end
return stats
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
if Application:isInstance(orig) and not Choice:isInstance(orig) then
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
trans = exp([[]], name2ast(orig.name, context), [[[]], orig.arguments[1], [=[]]=])
context.partials[orig.name[1][1]].vals[orig.arguments[1][1]] = true
else
local newcontext = context:new({})
local body = orig:toLuaAst(newcontext)
if #body == 0 and Literal:isInstance(newcontext.result) then
trans = newcontext.result
else
body:append(laststat([[return ]], newcontext.result, [[]]))
trans = exp([[function (input) ]], body, [[ end]])
end
end
return trans
end
function RuleApplication:toLuaAst(context)
local target = self.target and name2ast(self.target)
local ruleref = name2ast(self.name, context)
local arguments = Array({})
if not target and #self.arguments == 1 and Literal:isInstance(self.arguments[1]) and #self.name == 1 and context.partials[self.name[1][1]] then
ruleref = exp([[]], ruleref, [[[]], self.arguments[1], [=[]]=])
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
local stats = Array({})
if context.variable then
stats:append(stat([[]], context.variable, [[ = input:]], Name({fname}), [[(]], arguments, [[)]]))
else
context.result = exp([[input:]], Name({fname}), [[(]], arguments, [[)]])
end
return stats
end
function Object:toLuaAst(context)
rno = rno + 1
local var = '_table' .. tostring(rno)
local undostate = Name({var .. 'undo'})
local dostate = Name({var .. 'do'})
local tablevar = Name({var .. 'tab'})
local resvar = Name({var .. 'val'})
local newcontext = context:new({})
local stats = Array({stat([[local ]], undostate, [[ = input.stream]]), stat([[local ]], tablevar, [[, ]], resvar, [[ = input:next()]]), stat([[local ]], dostate, [[ = input.stream]]), stat([[input.stream = streams.TableInputStream:new(]], tablevar, [[)]])})
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
toLuaAst = function (tree, partials)
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
local ruleClone = exp([[{
          behavior = function(input) ]], body, [[ end;
          arity = 0,
          name = ]], StringLiteral({name .. '[' .. val .. ']'}), [[;
          count = 0,
          hits = 0,
          cache = 0;
        }]])
ruleAst.properties:append(SetProperty({index = StringLiteral({val}), expression = ruleClone}))
end
end
end
return ast
end
return {toLuaAst = toLuaAst}
