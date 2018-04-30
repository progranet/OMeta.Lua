local tostring, tonumber, select, type, getmetatable, setmetatable, rawget = tostring, tonumber, select, type, getmetatable, setmetatable, rawget
local Types = require('types')
local Any, Array = Types.Any, Types.Array
local OMeta = require('ometa')
local utils = require('utils')
local StdLib = require('ometa_stdlib')
local Commons = OMeta.Grammar({_grammarName = 'Commons', eos = OMeta.Rule({behavior = function (input)
          local __pass__
          return input:applyWithArgs(input.grammar.choice, function (input)
              return input:applyWithArgs(input.grammar.notPredicate, input.grammar.anything)
            end)
        end, arity = 0, grammar = nil, name = 'eos'}), empty = OMeta.Rule({behavior = function (input)
          local __pass__
          return input:applyWithArgs(input.grammar.choice, function (input)
              return true
            end)
        end, arity = 0, grammar = nil, name = 'empty'}), string = OMeta.Rule({behavior = function (input)
          local __pass__
          return input:applyWithArgs(input.grammar.choice, function (input)
              if not (type(input.stream._head) == 'string') then
                return false
              end
              return input:apply(input.grammar.anything)
            end)
        end, arity = 0, grammar = nil, name = 'string'}), number = OMeta.Rule({behavior = function (input)
          local __pass__
          return input:applyWithArgs(input.grammar.choice, function (input)
              if not (type(input.stream._head) == 'number') then
                return false
              end
              return input:apply(input.grammar.anything)
            end)
        end, arity = 0, grammar = nil, name = 'number'}), boolean = OMeta.Rule({behavior = function (input)
          local __pass__
          return input:applyWithArgs(input.grammar.choice, function (input)
              if not (type(input.stream._head) == 'boolean') then
                return false
              end
              return input:apply(input.grammar.anything)
            end)
        end, arity = 0, grammar = nil, name = 'boolean'}), table = OMeta.Rule({behavior = function (input)
          local __pass__
          return input:applyWithArgs(input.grammar.choice, function (input)
              if not (type(input.stream._head) == 'table') then
                return false
              end
              return input:apply(input.grammar.anything)
            end)
        end, arity = 0, grammar = nil, name = 'table'}), ['function'] = OMeta.Rule({behavior = function (input)
          local __pass__
          return input:applyWithArgs(input.grammar.choice, function (input)
              if not (type(input.stream._head) == 'function') then
                return false
              end
              return input:apply(input.grammar.anything)
            end)
        end, arity = 0, grammar = nil, name = 'function'}), notLast = OMeta.Rule({behavior = function (input, element)
          local __pass__, __result__
          return input:applyWithArgs(input.grammar.choice, function (input)
              __pass__, __result__ = input:apply(element)
              if not (__pass__) then
                return false
              end
              if not (input:applyWithArgs(input.grammar.andPredicate, element)) then
                return false
              end
              return true, __result__
            end)
        end, arity = 1, grammar = nil, name = 'notLast'}), list = OMeta.Rule({behavior = function (input, element, delim, minimum)
          local __pass__
          return input:applyWithArgs(input.grammar.choice, function (input)
              local __pass__, rest, first
              __pass__, first = input:apply(element)
              if not (__pass__) then
                return false
              end
              __pass__, rest = input:applyWithArgs(input.grammar.many, function (input)
                  return input:applyWithArgs(input.grammar.choice, function (input)
                      local __pass__
                      if not (input:apply(delim)) then
                        return false
                      end
                      return input:apply(element)
                    end)
                end)
              if not (__pass__) then
                return false
              end
              if not ((#rest + 1) >= (minimum or 0)) then
                return false
              end
              return true, rest:prepend(first)
            end, function (input)
              local __pass__
              if not (not minimum or minimum == 0) then
                return false
              end
              return true, Array({})
            end)
        end, arity = 3, grammar = nil, name = 'list'}), range = OMeta.Rule({behavior = function (input, first, last)
          local __pass__
          return input:applyWithArgs(input.grammar.choice, function (input)
              return input:applyWithArgs(input.grammar.consumed, function (input)
                  return input:applyWithArgs(input.grammar.choice, function (input)
                      if not (input:apply(first)) then
                        return false
                      end
                      if not (input:applyWithArgs(input.grammar.many, function (input)
                            return input:applyWithArgs(input.grammar.choice, function (input)
                                local __pass__
                                if not (input:applyWithArgs(input.grammar.notPredicate, last)) then
                                  return false
                                end
                                return input:apply(input.grammar.anything)
                              end)
                          end)) then
                        return false
                      end
                      return input:apply(last)
                    end)
                end)
            end)
        end, arity = 2, grammar = nil, name = 'range'})})
Commons:merge(StdLib)
return Commons
