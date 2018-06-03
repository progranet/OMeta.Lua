local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local Types = require('types')
local Any, Array = Types.Any, Types.Array
local OMeta = require('ometa')
local utils = require('utils')
local asc = require('abstractsyntax_commons')
local Literal, NilLiteral, BooleanLiteral, NumberLiteral, IntegerLiteral, RealLiteral, StringLiteral, Name, Keyword, Special, Node, Statement, Expression, Control, Iterative, Invocation = asc.Literal, asc.NilLiteral, asc.BooleanLiteral, asc.NumberLiteral, asc.IntegerLiteral, asc.RealLiteral, asc.StringLiteral, asc.Name, asc.Keyword, asc.Special, asc.Node, asc.Statement, asc.Expression, asc.Control, asc.Iterative, asc.Invocation
local Commons = require('commons')
local Aux = require('auxiliary')
local CharacterPatterns = OMeta.Grammar({_grammarName = 'CharacterPatterns', space = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.string)
if not (__pass__) then
return false
end
if not ((__result__):match('^%s$')) then
return false
end
return (__result__):match('^%s$'), __result__
end)
end, arity = 0, name = 'space'}), digit = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.string)
if not (__pass__) then
return false
end
if not ((__result__):match('^%d$')) then
return false
end
return (__result__):match('^%d$'), __result__
end)
end, arity = 0, name = 'digit'}), hexdigit = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.string)
if not (__pass__) then
return false
end
if not ((__result__):match('^%x$')) then
return false
end
return (__result__):match('^%x$'), __result__
end)
end, arity = 0, name = 'hexdigit'}), lower = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.string)
if not (__pass__) then
return false
end
if not ((__result__):match('^%l$')) then
return false
end
return (__result__):match('^%l$'), __result__
end)
end, arity = 0, name = 'lower'}), upper = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.string)
if not (__pass__) then
return false
end
if not ((__result__):match('^%u$')) then
return false
end
return (__result__):match('^%u$'), __result__
end)
end, arity = 0, name = 'upper'}), letter = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.string)
if not (__pass__) then
return false
end
if not ((__result__):match('^%a$')) then
return false
end
return (__result__):match('^%a$'), __result__
end)
end, arity = 0, name = 'letter'}), alphanum = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.string)
if not (__pass__) then
return false
end
if not ((__result__):match('^%w$')) then
return false
end
return (__result__):match('^%w$'), __result__
end)
end, arity = 0, name = 'alphanum'}), nameFirst = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.string)
if not (__pass__) then
return false
end
if not ((__result__):match('^[%a_]$')) then
return false
end
return (__result__):match('^[%a_]$'), __result__
end)
end, arity = 0, name = 'nameFirst'}), nameRest = OMeta.Rule({behavior = function (input)
local __result__, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, __result__ = input:apply(input.grammar.string)
if not (__pass__) then
return false
end
if not ((__result__):match('^[%w_]$')) then
return false
end
return (__result__):match('^[%w_]$'), __result__
end)
end, arity = 0, name = 'nameRest'}), nameString = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(Aux.pattern, '[%a_][%w_]*')
end)
end, arity = 0, name = 'nameString'})})
local CharacterSets = OMeta.Grammar({_grammarName = 'CharacterSets', space = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'string' and #input.stream._head == 1 and (input.stream._head):byte() <= 32) then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, name = 'space'}), digit = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'string' and #input.stream._head == 1 and input.stream._head >= '0' and input.stream._head <= '9') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, name = 'digit'}), hexdigit = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.digit)
end, function (input)
if not (type(input.stream._head) == 'string' and #input.stream._head == 1 and input.stream._head >= 'a' and input.stream._head <= 'f' or input.stream._head >= 'A' and input.stream._head <= 'F') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, name = 'hexdigit'}), lower = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'string' and #input.stream._head == 1 and input.stream._head >= 'a' and input.stream._head <= 'z') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, name = 'lower'}), upper = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'string' and #input.stream._head == 1 and input.stream._head >= 'A' and input.stream._head <= 'Z') then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, name = 'upper'}), letter = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.lower)
end, function (input)
return input:apply(input.grammar.upper)
end)
end, arity = 0, name = 'letter'}), alphanum = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.letter)
end, function (input)
return input:apply(input.grammar.digit)
end)
end, arity = 0, name = 'alphanum'}), nameFirst = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.letter)
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '_')
end)
end, arity = 0, name = 'nameFirst'}), nameRest = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.nameFirst)
end, function (input)
return input:apply(input.grammar.digit)
end)
end, arity = 0, name = 'nameRest'}), nameString = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:apply(input.grammar.nameFirst)) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.nameRest)
end)
end)
end)
end, arity = 0, name = 'nameString'})})
local GrammarCommons = OMeta.Grammar({_grammarName = 'GrammarCommons', comment = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.subsequence, [[--]])) then
return false
end
return input:apply(input.grammar.strlitL)
end)
end)
end, function (input)
return input:applyWithArgs(input.grammar.range, function (input)
return input:applyWithArgs(input.grammar.subsequence, [[--]])
end, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, '\n')
end, function (input)
return input:apply(input.grammar.eos)
end)
end)
end)
end, arity = 0, name = 'comment'}), ws = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.space)
end, function (input)
return input:apply(input.grammar.comment)
end)
end, arity = 0, name = 'ws'}), char = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (type(input.stream._head) == 'string' and #input.stream._head == 1) then
return false
end
return input:apply(input.grammar.anything)
end)
end, arity = 0, name = 'char'}), name = OMeta.Rule({behavior = function (input)
local ns, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
__pass__, ns = input:apply(input.grammar.nameString)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.notPredicate, function (input)
return input:applyWithArgs(input.grammar.keyword, ns)
end)) then
return false
end
return true, Name({ns})
end)
end, arity = 0, name = 'name'}), token = OMeta.Rule({behavior = function (input, str)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
return input:applyWithArgs(input.grammar.choice, function (input)
local s, __pass__
__pass__, s = input:apply(input.grammar.special)
if not (__pass__) then
return false
end
if not (str == s) then
return false
end
return true, Special({s})
end, function (input)
local ns, __pass__
__pass__, ns = input:apply(input.grammar.nameString)
if not (__pass__) then
return false
end
if not (str == ns) then
return false
end
if not (input:applyWithArgs(input.grammar.keyword, ns)) then
return false
end
return true, Keyword({ns})
end)
end)
end, arity = 1, name = 'token'}), escchar = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '\\')) then
return false
end
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end, function (input)
if not (input:applyWithArgs(input.grammar.exactly, 'x')) then
return false
end
return input:applyWithArgs(input.grammar.loop, input.grammar.hexdigit, 2)
end, function (input)
return input:apply(input.grammar.char)
end)
end)
end)
end)
end, arity = 0, name = 'escchar'}), strlitA = OMeta.Rule({behavior = function (input)
local str, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '\'')) then
return false
end
__pass__, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.escchar)
end, function (input)
if not (input:applyWithArgs(input.grammar.notPredicate, '\'')) then
return false
end
return input:apply(input.grammar.char)
end)
end)
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '\'')) then
return false
end
return true, StringLiteral({str})
end)
end, arity = 0, name = 'strlitA'}), strlitQ = OMeta.Rule({behavior = function (input)
local str, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '\"')) then
return false
end
__pass__, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.escchar)
end, function (input)
if not (input:applyWithArgs(input.grammar.notPredicate, '\"')) then
return false
end
return input:apply(input.grammar.char)
end)
end)
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '\"')) then
return false
end
return true, StringLiteral({str, ldelim = '"', rdelim = '"'})
end)
end, arity = 0, name = 'strlitQ'}), strlitB = OMeta.Rule({behavior = function (input)
local str, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '`')) then
return false
end
__pass__, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:apply(input.grammar.escchar)
end, function (input)
if not (input:applyWithArgs(input.grammar.notPredicate, '`')) then
return false
end
return input:apply(input.grammar.char)
end)
end)
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '`')) then
return false
end
return true, StringLiteral({str, ldelim = '`', rdelim = '`'})
end)
end, arity = 0, name = 'strlitB'}), strlitL = OMeta.Rule({behavior = function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local str, __pass__
if not (input:applyWithArgs(input.grammar.exactly, '[')) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '[')) then
return false
end
__pass__, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.notPredicate, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, ']')) then
return false
end
return input:applyWithArgs(input.grammar.exactly, ']')
end)
end)) then
return false
end
return input:apply(input.grammar.char)
end)
end)
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, ']')) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, ']')) then
return false
end
return true, StringLiteral({str, ldelim = '[[', rdelim = ']]'})
end, function (input)
local back, __pass__, eqs, str
if not (input:applyWithArgs(input.grammar.exactly, '[')) then
return false
end
__pass__, eqs = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, '=', 1)
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '[')) then
return false
end
__pass__, back = true, ']' .. eqs .. ']'
if not (__pass__) then
return false
end
__pass__, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.notPredicate, function (input)
return input:applyWithArgs(input.grammar.subsequence, back)
end)) then
return false
end
return input:apply(input.grammar.char)
end)
end)
end)
if not (__pass__) then
return false
end
if not (input:applyWithArgs(input.grammar.subsequence, back)) then
return false
end
return true, StringLiteral({str, ldelim = '[' .. eqs .. '[', rdelim = ']' .. eqs .. ']'})
end)
end, arity = 0, name = 'strlitL'}), intlit = OMeta.Rule({behavior = function (input)
local number, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, number = input:applyWithArgs(input.grammar.toNumber, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end)
if not (__pass__) then
return false
end
return true, IntegerLiteral({number})
end)
end, arity = 0, name = 'intlit'}), reallit = OMeta.Rule({behavior = function (input)
local number, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, number = input:applyWithArgs(input.grammar.toNumber, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '.')) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit)
end, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '.')) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)) then
return false
end
return input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, 'e')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'E')
end)) then
return false
end
if not (input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, '+')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, '-')
end)
end)) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
end)
end)
end)
end)
if not (__pass__) then
return false
end
return true, RealLiteral({number})
end)
end, arity = 0, name = 'reallit'}), hexlit = OMeta.Rule({behavior = function (input)
local number, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, number = input:applyWithArgs(input.grammar.toNumber, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '0')) then
return false
end
if not (input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.exactly, 'x')
end, function (input)
return input:applyWithArgs(input.grammar.exactly, 'X')
end)) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.hexdigit, 1)
end)
end)
end)
if not (__pass__) then
return false
end
return true, IntegerLiteral({number})
end)
end, arity = 0, name = 'hexlit'}), boollit = OMeta.Rule({behavior = function (input)
local str, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, str = input:apply(input.grammar.nameString)
if not (__pass__) then
return false
end
if not (str == 'true' or str == 'false') then
return false
end
return true, BooleanLiteral({str == 'true'})
end)
end, arity = 0, name = 'boollit'}), nillit = OMeta.Rule({behavior = function (input)
local str, __pass__
return input:applyWithArgs(input.grammar.choice, function (input)
__pass__, str = input:apply(input.grammar.nameString)
if not (__pass__) then
return false
end
if not (str == 'nil') then
return false
end
return true, NilLiteral({})
end)
end, arity = 0, name = 'nillit'})})
GrammarCommons:merge(Commons)
GrammarCommons:merge(CharacterSets)
return GrammarCommons
