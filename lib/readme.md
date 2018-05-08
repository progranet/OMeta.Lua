Libraries required by OMeta/Lua implementation:
- *streams.lua* - contains implementations of supported kinds of stream;
- *types.lua* - provides very simple type system implementation. Types are used by OMeta/Lua implementation internally and can be used to build such a models as abstract syntax trees. However user do not need to use this types to write own Grammars;
- *utils.lua* - provides some extensions to Lua primitive types and libraries and several helper functions (to work with file system for example);
