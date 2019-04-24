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

### `compile_line`

parses a line and returns its machine code as a series of bytes. nil is
returned if the line does not match any mnemonic.

example:

```
> lgbtasm = require 'lgbtasm'
> lgbtasm.compile_line('ld a,3f')
62      63
```


### `compile_block`

parses a series of instructions and returns the entire block as a byte string.
the optional `delimiters` argument determines what characters can separate
instructions in the input; it defaults to the newline character.

example:

```
> lgbtasm = require 'lgbtasm'
> lgbtasm.compile_block('cp b; ret', ';') == '\xb8\xc9'
true
```
