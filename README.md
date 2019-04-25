# Lua Game Boy: The Assembler

## Summary

The good:

- Converts assembly to machine code
- Converts machine code to assembly
- No external dependencies
- Lua 5.1 compatible

The bad:

- Not very tested
- Has no notion of labels
- Very limited command language
- It's only a module and nothing executable


## Usage

This module uses bgb / no$gmb syntax, although instruction arguments can
optionally be prefixed with `$`. In other words, `ld a,3f` and `ld a,$3f`
are both acceptable. Additionally, `a,` can be omitted from mnemonics—so
`ld 3f` is also valid. Instructions, arguments, and keywords are
case-insensitive.

The characters in `/#;-` all begin inline comments, although instruction
delimiter status overrides comment character status in the `compile()`
function.


## Functions

### `compile(block, delimiters)`

Parses a series of instructions and returns the equivalent machine code as a
byte string. The optional `delimiters` argument determines what characters
can separate instructions in the input; it defaults to `'\n'`. Generates an
error if an instruction does not match any mnemonic, or if an invalid
argument is given to an instruction.

```
> lgbtasm = require 'lgbtasm'
> lgbtasm.compile('cp b; ret', ';') == '\xb8\xc9'
true
```

### `decompile(block, delimiter)`

Converts a string of machine code into an asm string with instructions
separated by the optional `delimiter` argument, which defaults to `'\n'`.
Generates an error if an opcode is invalid, or if not enough bytes remain in
the string to satisfy an instruction's argument.

```
> lgbtasm = require 'lgbtasm'
> lgbtasm.decompile('\xb8\xc9', '; ')
cp b; ret
```


## Commands

The following syntax is represented in bastardized EBNF.

### `db d8{,d8}`

Defines a sequence of comma-separated byte literals.

```
> lgbtasm = require 'lgbtasm'
> lgbtasm.compile('db 01,02') == '\x01\x02'
true
```
