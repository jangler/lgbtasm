#!/usr/bin/env lua

lgbtasm = require '.../lgbtasm'

-- compiling instructions:

-- invalid instruction
status = pcall(lgbtasm.compile, 'invalid')
assert(status == false)

-- nullary instruction
s = lgbtasm.compile('ld b,a')
assert(s == '\x47')

-- unary instruction
s = lgbtasm.compile('ld a,$3f')
assert(s == '\x3e\x3f')

-- unary instruction without $
s = lgbtasm.compile('ld a,3f')
assert(s == '\x3e\x3f')

-- unary instruction without 'a,'
s = lgbtasm.compile('ld 3f')
assert(s == '\x3e\x3f')

-- binary instruction
s = lgbtasm.compile('ld hl,$c692')
assert(s == '\x21\x92\xc6')

-- binary instruction without $
s = lgbtasm.compile('ld hl,c692')
assert(s == '\x21\x92\xc6')

-- instruction involving an address
s = lgbtasm.compile('ld a,(cc49)')
assert(s == '\xfa\x49\xcc')

-- prefix cb instruction
s = lgbtasm.compile('bit 4,a')
assert(s == '\xcb\x67')

-- ldh-type instruction
s = lgbtasm.compile('ld ($ff00+b5),a')
assert(s == '\xe0\xb5')

-- line with indent and comment
s = lgbtasm.compile('    cp b -- comment')
assert(s == '\xb8')

-- block with single instruction
s = lgbtasm.compile('ld bc,0601')
assert(s == '\x01\x01\x06')

-- block with multiple instructions, semicolon-delimited
s = lgbtasm.compile('cp b; ret', ';')
assert(s == '\xb8\xc9')

-- block with multiple instructions, newline-delimited
s = lgbtasm.compile('cp b\nret')
assert(s == '\xb8\xc9')

-- block with commented blank line
s = lgbtasm.compile('cp b\n; comment\nret')
assert(s == '\xb8\xc9')

-- block with invalid instruction
status = pcall(lgbtasm.compile, 'cp b\ninvalid\nret')
assert(status == false)

-- forward jump to label
s = lgbtasm.compile('jr .next; cp a,49; .next', ';')
assert(s == '\x18\x02\xfe\x49')

-- backward jump to label
s = lgbtasm.compile('.loop; cp a,49; jr .loop', ';')
assert(s == '\xfe\x49\x18\xfc')

-- multiple labels
s = lgbtasm.compile([[.loop
ld a,a
jr .next
.loop2
ld a,b
jr .next2
ld a,c
jr .next
.next
ld a,d
jr .loop2
.next2
ld a,e
jr .loop]])
assert(s == '\x7f\x18\x06\x78\x18\x06\x79\x18\x00\x7a\x18\xf7\x7b\x18\xf1')


-- compiling assembler commands:

-- invalid db
status = pcall(lgbtasm.compile, 'db')
assert(status == false)

-- single-entry db
s = lgbtasm.compile('db 1a')
assert(s == '\x1a')

-- multiple-entry db w/ inconsistent formatting
s = lgbtasm.compile('db 1a,$2b, 3c')
assert(s == '\x1a\x2b\x3c')


-- decompiling:

-- decompile invalid opcode
status = pcall(lgbtasm.decompile, '\xd3')
assert(status == false)

-- decompile unary instruction w/o enough data for arg
status = pcall(lgbtasm.decompile, '\x3e')
assert(status == false)

-- decompile binary instruction w/o enough data for arg
status = pcall(lgbtasm.decompile, '\x21\x92')
assert(status == false)

-- decompile prefix cb instruction w/o enough data for arg
status = pcall(lgbtasm.decompile, '\xcb')
assert(status == false)

-- decompile nullary instruction
s = lgbtasm.decompile('\xaf')
assert(s == 'xor a')

-- decompile unary instruction
s = lgbtasm.decompile('\x3e\x3f')
assert(s == 'ld a,3f')

-- decompile binary instruction
s = lgbtasm.decompile('\x21\x92\xc6')
assert(s == 'ld hl,c692')

-- decompile prefix cb instruction
s = lgbtasm.decompile('\xcb\x67')
assert(s == 'bit 4,a')

-- decompile ldh-type instruction
s = lgbtasm.decompile('\xe0\xb5')
assert(s == 'ld (ff00+b5),a')

-- decompile block
s = lgbtasm.decompile('\x3e\x3f\xcb\x67\xc9', '; ')
assert(s == 'ld a,3f; bit 4,a; ret')

-- decompile forward jump to label
s = lgbtasm.decompile('\x18\x02\xfe\x49\xc9', '; ')
assert(s == 'jr .next; cp a,49; .next; ret')

-- decompile backward jump to label
s = lgbtasm.decompile('\xfe\x49\x18\xfc', '; ')
assert(s == '.loop; cp a,49; jr .loop')

-- decompile multiple labels
s = lgbtasm.decompile(
    '\x7f\x18\x06\x78\x18\x06\x79\x18\x00\x7a\x18\xf7\x7b\x18\xf1')
assert(s == [[.loop
ld a,a
jr .next
.loop2
ld a,b
jr .next2
ld a,c
jr .next
.next
ld a,d
jr .loop2
.next2
ld a,e
jr .loop]])
