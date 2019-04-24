#!/usr/bin/env lua

lgbtasm = require '.../lgbtasm'

-- invalid instruction
x, y, z  = lgbtasm.compile_line('invalid')
assert(x == nil and y == nil and z == nil)

-- nullary instruction
x, y, z = lgbtasm.compile_line('ld b,a')
assert(x == 0x47 and y == nil and z == nil)

-- unary instruction
x, y, z  = lgbtasm.compile_line('ld a,$3f')
assert(x == 0x3e and y == 0x3f and z == nil)

-- unary instruction without $
x, y, z  = lgbtasm.compile_line('ld a,3f')
assert(x == 0x3e and y == 0x3f and z == nil)

-- unary instruction without 'a,'
x, y, z  = lgbtasm.compile_line('ld 3f')
assert(x == 0x3e and y == 0x3f and z == nil)

-- binary instruction
x, y, z = lgbtasm.compile_line('ld hl,$c692')
assert(x == 0x21 and y == 0x92 and z == 0xc6)

-- binary instruction without $
x, y, z = lgbtasm.compile_line('ld hl,c692')
assert(x == 0x21 and y == 0x92 and z == 0xc6)

-- prefix cb instruction
x, y, z = lgbtasm.compile_line('bit 4,a')
assert(x == 0xcb and y == 0x67 and z == nil)

-- ldh-type instruction
x, y, z = lgbtasm.compile_line('ld ($ff00+b5),a')
assert(x == 0xe0 and y == 0xb5 and z == nil)

-- line with indent and comment
x, y, z = lgbtasm.compile_line('    cp b -- comment')
assert(x == 0xb8 and y == nil and z == nil)

-- block with single instruction
s = lgbtasm.compile_block('ld bc,0601')
assert(s == string.char(0x01, 0x01, 0x06))

-- block with multiple instructions, semicolon-delimited
s = lgbtasm.compile_block('cp b; ret', ';')
assert(s == string.char(0xb8, 0xc9))

-- block with multiple instructions, newline-delimited
s = lgbtasm.compile_block('cp b\nret')
assert(s == string.char(0xb8, 0xc9))
