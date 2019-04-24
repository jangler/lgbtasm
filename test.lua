#!/usr/bin/env lua

lgbtasm = require '.../lgbtasm'

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

-- block with invalid instruction
status = pcall(lgbtasm.compile, 'cp b\ninvalid\nret')
assert(status == false)

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
