# Lua Game Boy: The Assembler

who even knows what this is

the good:

- converts instructions to machine code
- lua 5.1 compatible

the bad:

- not very tested
- has no notion of labels
- it's only a module and nothing executable


## usage

### `compile_line()`

parses a line and returns its machine code as a byte string. generates an
error if the line does not match any mnemonic, or if an invalid argument is
given to an instruction.

```
> lgbtasm = require 'lgbtasm'
> lgbtasm.compile_line('ld a,3f') == '\x3e\x3f'
true
```


### `compile_block()`

parses a series of instructions and returns the entire block as a byte
string. the optional `delimiters` argument determines what characters can
separate instructions in the input; it defaults to the newline character.
propogates errors as returned by `compile_line()`.

```
> lgbtasm = require 'lgbtasm'
> lgbtasm.compile_block('cp b; ret', ';') == '\xb8\xc9'
true
```
