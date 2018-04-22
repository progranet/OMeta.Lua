package.path = './model/?.lua;./ometa/?.lua;./lib/?.lua;./?.lua;' .. package.path

local utils = require 'utils'
local Types = require 'types'
local Any, Array = Types.Any, Types.Array

local OMeta = require 'ometa'
local Model = require 'ometa_abstractsyntax'
local Grammar = require 'ometa_lua_grammar'.OMetaInLuaGrammar

local alt = {'reference'}

local OMetaToLuaTranslator = require('ometa_ast2lua_ast_' .. alt[1])
local ToSourceTranslator = require 'lua_ast2source'

local function parseFile(path)
  --local ometa = OMeta.use(Grammar):forFile(path)
  return utils.measure(
    function() 
      --return ometa:match(Grammar.block) 
      return Grammar.block:matchFile(path)
    end
  )
end

local function translateTree(tree)
  return utils.measure(
    function() 
      return OMetaToLuaTranslator.toLuaAst(tree)
    end
  )
end

local function generateSourceTrans(tree)
  --local ometa = OMeta.use(ToSourceTranslator):forTable(Array {tree})
  return utils.measure(
    function() 
      --return ometa:match(ToSourceTranslator.trans)
      return ToSourceTranslator.trans:matchMixed(tree)
    end
  )
end

local function generateSourceDirect(tree)
  return utils.measure(
    function() 
      return tree:toLuaSource()
    end
  )
end

local function compileFile(name)
  print('compilation:', name)
  local ometaAst = parseFile(name .. '.lpp')
  --utils.writeFile(name .. '.oast', tostring(ometaAst))
  local luaAst = translateTree(ometaAst)
  --utils.writeFile(name .. '.last', tostring(luaAst))
  --local luaSource = generateSourceDirect(luaAst)
  local luaSource = generateSourceTrans(luaAst)
  utils.writeFile(name .. '.lua', luaSource)
  print('============================')
end

local libs = {'commons','grammar_commons','binary_commons','auxiliary','lua_grammar','lua52_grammar','ometa_grammar','ometa_lua_grammar','ometa_ast2lua_ast_' .. alt[1],'lua_ast2source'}

return {
  parseFile = parseFile,
  translateTree = translateTree,
  generateSource = generateSource,
  compileFile = compileFile;
  
  build = function() 
    for l = 1, #libs do 
      local pass, res = pcall(compileFile, './ometa/' .. libs[l])
      if not pass then
        print(res)
      end
    end
  end;
}
