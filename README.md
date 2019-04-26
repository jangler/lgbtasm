# Lua Game Boy: The Assembler

## Summary

The good:

- Converts assembly to machine code
- Converts machine code to assembly
- No external dependencies
- Lua 5.1 compatible

The bad:

- Not very tested
- Very limited command language
- It's only a module and nothing executable


## Usage

This module uses bgb/no$gmb syntax, and enforces a strict style: numbers are
always undecorated (no `$`, etc.) and hexadecimal, `a,` is always required
in mnemonics that feature it, and all keywords and digits are lower-case.
User-defined symbols such as labels are case-sensitive. A label and
instruction cannot appear on the same line.

The characters in `;*#` all begin inline comments, although instruction
delimiter status overrides comment character status in the `compile()`
function.

"Local" labels (the only kind) start with a `.` and can be referenced by
relative jumps. Decompilation automatically generates labels for relative
jump destinations.


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
