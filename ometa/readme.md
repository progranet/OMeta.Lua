Folder contains whole hierarchy of OMeta Grammars used by OMeta/Lua implementation itself.

Grammars are divided and written in such a way that:
- each Grammar can be used independently as much as possible;
- each Grammar has some level of abstraction - e.g.: Grammar may be independent of Lua types, may be specific to some specific kind of input stream, Grammar can "produce" only values of primitive types or abstract syntax trees;
- depending on his needs user selects, "requires" and merges specific Grammars in a detailed way - e.g.: other Grammars should be composed if user need to parse binary file where words are encoded in *Big Endian* and bits in bitfields are ordered most significant bit first (*MSB0*) and other Grammars are needed when user writes Lua syntax extension;
