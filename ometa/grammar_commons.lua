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
local _pass, any
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, any = input:apply(input.grammar.string)
if not (_pass) then
return false
end
if not (any:match('^%s$')) then
return false
end
return true, any
end)
end, arity = 0, grammar = nil, name = 'space'}), digit = OMeta.Rule({behavior = function (input)
local _pass, any
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, any = input:apply(input.grammar.string)
if not (_pass) then
return false
end
if not (any:match('^%d$')) then
return false
end
return true, any
end)
end, arity = 0, grammar = nil, name = 'digit'}), hexdigit = OMeta.Rule({behavior = function (input)
local _pass, any
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, any = input:apply(input.grammar.string)
if not (_pass) then
return false
end
if not (any:match('^%x$')) then
return false
end
return true, any
end)
end, arity = 0, grammar = nil, name = 'hexdigit'}), lower = OMeta.Rule({behavior = function (input)
local _pass, any
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, any = input:apply(input.grammar.string)
if not (_pass) then
return false
end
if not (any:match('^%l$')) then
return false
end
return true, any
end)
end, arity = 0, grammar = nil, name = 'lower'}), upper = OMeta.Rule({behavior = function (input)
local _pass, any
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, any = input:apply(input.grammar.string)
if not (_pass) then
return false
end
if not (any:match('^%u$')) then
return false
end
return true, any
end)
end, arity = 0, grammar = nil, name = 'upper'}), letter = OMeta.Rule({behavior = function (input)
local _pass, any
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, any = input:apply(input.grammar.string)
if not (_pass) then
return false
end
if not (any:match('^%a$')) then
return false
end
return true, any
end)
end, arity = 0, grammar = nil, name = 'letter'}), alphanum = OMeta.Rule({behavior = function (input)
local _pass, any
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, any = input:apply(input.grammar.string)
if not (_pass) then
return false
end
if not (any:match('^%w$')) then
return false
end
return true, any
end)
end, arity = 0, grammar = nil, name = 'alphanum'}), nameFirst = OMeta.Rule({behavior = function (input)
local _pass, any
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, any = input:apply(input.grammar.string)
if not (_pass) then
return false
end
if not (any:match('^[%a_]$')) then
return false
end
return true, any
end)
end, arity = 0, grammar = nil, name = 'nameFirst'}), nameRest = OMeta.Rule({behavior = function (input)
local _pass, any
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, any = input:apply(input.grammar.string)
if not (_pass) then
return false
end
if not (any:match('^[%w_]$')) then
return false
end
return true, any
end)
end, arity = 0, grammar = nil, name = 'nameRest'}), nameString = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(Aux.pattern, '[%a_][%w_]*')
end)
end, arity = 0, grammar = nil, name = 'nameString'})})
local CharacterSets = OMeta.Grammar({_grammarName = 'CharacterSets', space = OMeta.Rule({behavior = function (input)
local _pass, char
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, char = input:apply(input.grammar.char)
if not (_pass) then
return false
end
if not (char:byte() <= 32) then
return false
end
return true, char
end)
end, arity = 0, grammar = nil, name = 'space'}), digit = OMeta.Rule({behavior = function (input)
local _pass, char
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, char = input:apply(input.grammar.char)
if not (_pass) then
return false
end
if not (char >= '0' and char <= '9') then
return false
end
return true, char
end)
end, arity = 0, grammar = nil, name = 'digit'}), hexdigit = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.digit, function (input)
local _pass, char
_pass, char = input:apply(input.grammar.char)
if not (_pass) then
return false
end
if not (char >= 'a' and char <= 'f' or char >= 'A' and char <= 'F') then
return false
end
return true, char
end)
end, arity = 0, grammar = nil, name = 'hexdigit'}), lower = OMeta.Rule({behavior = function (input)
local _pass, char
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, char = input:apply(input.grammar.char)
if not (_pass) then
return false
end
if not (char >= 'a' and char <= 'z') then
return false
end
return true, char
end)
end, arity = 0, grammar = nil, name = 'lower'}), upper = OMeta.Rule({behavior = function (input)
local _pass, char
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, char = input:apply(input.grammar.char)
if not (_pass) then
return false
end
if not (char >= 'A' and char <= 'Z') then
return false
end
return true, char
end)
end, arity = 0, grammar = nil, name = 'upper'}), letter = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.lower, input.grammar.upper)
end, arity = 0, grammar = nil, name = 'letter'}), alphanum = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.letter, input.grammar.digit)
end, arity = 0, grammar = nil, name = 'alphanum'}), nameFirst = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.letter, function (input)
return input:applyWithArgs(input.grammar.exactly, '_')
end)
end, arity = 0, grammar = nil, name = 'nameFirst'}), nameRest = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.nameFirst, input.grammar.digit)
end, arity = 0, grammar = nil, name = 'nameRest'}), nameString = OMeta.Rule({behavior = function (input)
local _pass
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
end, arity = 0, grammar = nil, name = 'nameString'})})
local GrammarCommons = OMeta.Grammar({_grammarName = 'GrammarCommons', comment = OMeta.Rule({behavior = function (input)
local _pass
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
end, input.grammar.eos)
end)
end)
end, arity = 0, grammar = nil, name = 'comment'}), ws = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, input.grammar.space, input.grammar.comment)
end, arity = 0, grammar = nil, name = 'ws'}), name = OMeta.Rule({behavior = function (input)
local _pass, ns
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
_pass, ns = input:apply(input.grammar.nameString)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.notPredicate, function (input)
return input:applyWithArgs(input.grammar.keyword, ns)
end)) then
return false
end
return true, Name({ns})
end)
end, arity = 0, grammar = nil, name = 'name'}), token = OMeta.Rule({behavior = function (input, str)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.many, input.grammar.ws)) then
return false
end
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, s
_pass, s = input:apply(input.grammar.special)
if not (_pass) then
return false
end
if not (str == s) then
return false
end
return true, Special({s})
end, function (input)
local _pass, ns
_pass, ns = input:apply(input.grammar.nameString)
if not (_pass) then
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
end, arity = 1, grammar = nil, name = 'token'}), escchar = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '\\')) then
return false
end
return input:applyWithArgs(input.grammar.choice, function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end, input.grammar.char)
end)
end)
end)
end, arity = 0, grammar = nil, name = 'escchar'}), strlitA = OMeta.Rule({behavior = function (input)
local _pass, str
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '\'')) then
return false
end
_pass, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, input.grammar.escchar, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.notPredicate, '\'')) then
return false
end
return input:apply(input.grammar.char)
end)
end)
end)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '\'')) then
return false
end
return true, StringLiteral({str})
end)
end, arity = 0, grammar = nil, name = 'strlitA'}), strlitQ = OMeta.Rule({behavior = function (input)
local _pass, str
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '\"')) then
return false
end
_pass, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, input.grammar.escchar, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.notPredicate, '\"')) then
return false
end
return input:apply(input.grammar.char)
end)
end)
end)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '\"')) then
return false
end
return true, StringLiteral({str, ldelim = '"', rdelim = '"'})
end)
end, arity = 0, grammar = nil, name = 'strlitQ'}), strlitB = OMeta.Rule({behavior = function (input)
local _pass, str
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.exactly, '`')) then
return false
end
_pass, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, input.grammar.escchar, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.notPredicate, '`')) then
return false
end
return input:apply(input.grammar.char)
end)
end)
end)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '`')) then
return false
end
return true, StringLiteral({str, ldelim = '`', rdelim = '`'})
end)
end, arity = 0, grammar = nil, name = 'strlitB'}), strlitL = OMeta.Rule({behavior = function (input)
local _pass
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass, str
if not (input:applyWithArgs(input.grammar.exactly, '[')) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '[')) then
return false
end
_pass, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.notPredicate, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
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
if not (_pass) then
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
local _pass, back, eqs, str
if not (input:applyWithArgs(input.grammar.exactly, '[')) then
return false
end
_pass, eqs = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, '=', 1)
end)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '[')) then
return false
end
_pass, back = true, ']' .. eqs .. ']'
if not (_pass) then
return false
end
_pass, str = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.notPredicate, function (input)
return input:applyWithArgs(input.grammar.subsequence, back)
end)) then
return false
end
return input:apply(input.grammar.char)
end)
end)
end)
if not (_pass) then
return false
end
if not (input:applyWithArgs(input.grammar.subsequence, back)) then
return false
end
return true, StringLiteral({str, ldelim = '[' .. eqs .. '[', rdelim = ']' .. eqs .. ']'})
end)
end, arity = 0, grammar = nil, name = 'strlitL'}), intlit = OMeta.Rule({behavior = function (input)
local _pass, number
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, number = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)
if not (_pass) then
return false
end
return true, IntegerLiteral({tonumber(number)})
end)
end, arity = 0, grammar = nil, name = 'intlit'}), reallit = OMeta.Rule({behavior = function (input)
local _pass, number
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, number = input:applyWithArgs(input.grammar.consumed, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
if not (input:applyWithArgs(input.grammar.choice, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)) then
return false
end
if not (input:applyWithArgs(input.grammar.exactly, '.')) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit)
end, function (input)
local _pass
if not (input:applyWithArgs(input.grammar.exactly, '.')) then
return false
end
return input:applyWithArgs(input.grammar.many, input.grammar.digit, 1)
end)) then
return false
end
return input:applyWithArgs(input.grammar.optional, function (input)
return input:applyWithArgs(input.grammar.choice, function (input)
local _pass
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
if not (_pass) then
return false
end
return true, RealLiteral({tonumber(number)})
end)
end, arity = 0, grammar = nil, name = 'reallit'}), hexlit = OMeta.Rule({behavior = function (input)
local _pass, number
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, number = input:applyWithArgs(input.grammar.consumed, function (input)
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
if not (_pass) then
return false
end
return true, IntegerLiteral({tonumber(number)})
end)
end, arity = 0, grammar = nil, name = 'hexlit'}), boollit = OMeta.Rule({behavior = function (input)
local _pass, str
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, str = input:apply(input.grammar.nameString)
if not (_pass) then
return false
end
if not (str == 'true' or str == 'false') then
return false
end
return true, BooleanLiteral({str == 'true'})
end)
end, arity = 0, grammar = nil, name = 'boollit'}), nillit = OMeta.Rule({behavior = function (input)
local _pass, str
return input:applyWithArgs(input.grammar.choice, function (input)
_pass, str = input:apply(input.grammar.nameString)
if not (_pass) then
return false
end
if not (str == 'nil') then
return false
end
return true, NilLiteral({})
end)
end, arity = 0, grammar = nil, name = 'nillit'})})
GrammarCommons:merge(Commons)
GrammarCommons:merge(CharacterSets)
return GrammarCommons
