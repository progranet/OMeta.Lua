**1.0.2-beta 2018-04-27**

Improvement:
- primitive values (strings, booleans, numbers) can be passed as a Rule application arguments directly (without using Host Expresions). E.g.: `varchar([5])` can be simplified to `varchar(5)`
___
**1.0.1-beta 2018-04-26**

Bug fixed:
- Application of Rule with name which is Lua Keyword is properly generated now.

New example:
- Factorial Grammar - OMeta/JS example with pseudo-polymorphic Rule translated to OMeta/Lua.
___
**1.0.0-beta 2018-04-22**

Features implemented:
- OMeta engine
  - an application with arguments
    - prepending extra arguments to the input stream
  - an application of standard Lua functions
  - an "application" of *Types::Any* subtype - the type inclusion test (*instanceOf*)
  - a foreign application
    - a single Rule from the "foreign" Grammar (namespace) within the current parsing context
    - switching parsing contexts -an embedding of whole Grammars
  - a memoization
    - prepended arguments memoization - default
    - direct arguments (forwarded to Lua function) memoization on demand
  - a left recursion
- Streams
  - list streams
    - a character stream
    - a table (array) stream
    - a binary (byte) stream
  - prepending streams
  - a property stream (matching named table properties)
- an Input
  - string - to create a character stream
  - file
    - to create a character stream - text mode, default
    - to create a binary (byte) stream - binary mode
  - table
    - to create table (array) stream
    - to create property streams - "random access"
- a Grammar class
  - merge Rules - cloning Rules from existing Grammars into "derived" one
- a Rule class
  - defining packages of Rules (Grammars)
  - defining a standalone Rule
  - a direct Rule application
    - to match a string
    - to match a table (array)
    - to match a sequence of mixed elements
    - to match a file
      - match text file
      - match binary file
- Writing sources
  - a syntax extension for writing Grammars - a new Keyword (*ometa*)
  - a syntax extension for writing standalone Rules - a new Keyword (*rule*)
  - a syntax extension for a string interpolation - a new Special character (*backtick*)
- a Type system
  - Literal data types
  - AST classes for Lua abstract syntax
  - AST classes for OMeta abstract syntax
  - an Array type for convenient manipulation of Node sequences
  - multiple inheritance with C3 method resolution order
  - *getType* global function to get instance's type
  - `type::isInstance(instance : any) : boolean` - a method for type inclusion testing
- Grammars implemented
  - the standalone Lua 5.1 Grammar
  - the standalone Lua 5.2 Grammar - as 5.1 extension
  - the standalone OMeta Grammar
  - Lua embedded in OMeta Grammar for Host Nodes
  - the complete OMeta embedded in Lua Grammar - for the source text
  - OMeta in Lua mixed content Grammar - for heterogeneous streams
- Translation
  - the reference OMeta abstract syntax into the Lua abstract syntax translator
  - the Lua abstract syntax into the Lua source translator
    - implemented as OMeta Grammar
    - implemented as a feature of Lua abstract syntax Node types (*toLuaSource* method)

Non-functional "features":
- OMeta/Lua Grammar is not exactly the same as OMeta/JS Grammar. There are some differences resulting from adaptation to Lua specifics and from slightly different assumptions.
- The current optimization is poor. The reference OMeta AST to Lua AST translator produces a simple but inefficient code. A new version of translator producing more "linear" (optimizable better) Lua source code will be available "soon".
- The Naming convention for types and features is deliberately non-Luaish. This is due to the fact that the project is a part of a larger effort based on such specifications as Unified Modeling Language or Meta-Object Facility and the convention was adopted in accordance with those specifications.
