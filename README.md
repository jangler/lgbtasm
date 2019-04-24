# Lua Game Boy: The Assembler

who even knows what this is

the good:

- converts assembly to machine code
- converts machine code to assembly
- lua 5.1 compatible

the bad:

- not very tested
- has no notion of labels
- it's only a module and nothing executable


## usage

### `compile(block, delimiters)`

parses a series of instructions and returns the block as a byte string. the
optional `delimiters` argument determines what characters can separate
instructions in the input; it defaults to `'\n'`. generates an error if an
instruction does not match any mnemonic, or if an invalid argument is given
to an instruction.

```
> lgbtasm = require 'lgbtasm'
> lgbtasm.compile('cp b; ret', ';') == '\xb8\xc9'
true
```

### `decompile(block, delimiters)`

converts a string of machine code into an asm string with instructions
separated by the optional `delimiter` argument, which defaults to `'\n'`.
generates an error if an opcode is invalid, or if not enough bytes remain in
the string to satisfy an instruction's argument.

```
> lgbtasm = require 'lgbtasm'
> lgbtasm.decompile('\xb8\xc9', '; ')
cp b; ret
```
