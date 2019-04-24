#!/usr/bin/env lua

lgbtasm = require '.../lgbtasm'

-- invalid instruction
status = pcall(lgbtasm.compile_line, 'invalid')
assert(status == false)

-- nullary instruction
s = lgbtasm.compile_line('ld b,a')
assert(s == '\x47')

-- unary instruction
s = lgbtasm.compile_line('ld a,$3f')
assert(s == '\x3e\x3f')

-- unary instruction without $
s = lgbtasm.compile_line('ld a,3f')
assert(s == '\x3e\x3f')

-- unary instruction without 'a,'
s = lgbtasm.compile_line('ld 3f')
assert(s == '\x3e\x3f')

-- binary instruction
s = lgbtasm.compile_line('ld hl,$c692')
assert(s == '\x21\x92\xc6')

-- binary instruction without $
s = lgbtasm.compile_line('ld hl,c692')
assert(s == '\x21\x92\xc6')

-- prefix cb instruction
s = lgbtasm.compile_line('bit 4,a')
assert(s == '\xcb\x67')

-- ldh-type instruction
s = lgbtasm.compile_line('ld ($ff00+b5),a')
assert(s == '\xe0\xb5')

-- line with indent and comment
s = lgbtasm.compile_line('    cp b -- comment')
assert(s == '\xb8')

-- block with single instruction
s = lgbtasm.compile_block('ld bc,0601')
assert(s == '\x01\x01\x06')

-- block with multiple instructions, semicolon-delimited
s = lgbtasm.compile_block('cp b; ret', ';')
assert(s == '\xb8\xc9')

-- block with multiple instructions, newline-delimited
s = lgbtasm.compile_block('cp b\nret')
assert(s == '\xb8\xc9')

-- block with invalid instruction
status = pcall(lgbtasm.compile_line, 'cp b\ninvalid\nret')
assert(status == false)

-- decompile invalid instruction
status = pcall(lgbtasm.decompile_block, '\xd3')
assert(status == false)

-- decompile nullary instruction
s = lgbtasm.decompile_block('\xaf')
assert(s == 'xor a')

-- decompile unary instruction
s = lgbtasm.decompile_block('\x3e\x3f')
assert(s == 'ld a,3f')

-- decompile binary instruction
s = lgbtasm.decompile_block('\x21\x92\xc6')
assert(s == 'ld hl,c692')

-- decompile prefix cb instruction
s = lgbtasm.decompile_block('\xcb\x67')
assert(s == 'bit 4,a')

-- decompile block
s = lgbtasm.decompile_block('\x3e\x3f\xcb\x67\xc9', '; ')
assert(s == 'ld a,3f; bit 4,a; ret')
