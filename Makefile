CFLAGS = -w -g

CLEANFILES =				\
	lisp				\
	lisp.o				\
	lisp.o				\
	bestline.o			\
	sectorlisp.o			\
	sectorlisp.bin			\
	sectorlisp.bin.dbg		\
	brainfuck.o			\
	brainfuck.bin			\
	brainfuck.bin.dbg

.PHONY:	all
all:	lisp				\
	sectorlisp.bin			\
	sectorlisp.bin.dbg		\
	brainfuck.bin			\
	brainfuck.bin.dbg

.PHONY:	clean
clean:;	$(RM) $(CLEANFILES)

lisp: lisp.o bestline.o
lisp.o: lisp.js bestline.h
bestline.o: bestline.c bestline.h

sectorlisp.o: sectorlisp.S
	$(AS) -g -o $@ $<

sectorlisp.bin.dbg: sectorlisp.o
	$(LD) -oformat:binary -Ttext=0x0000 -o $@ $<

sectorlisp.bin: sectorlisp.bin.dbg
	objcopy -S -O binary sectorlisp.bin.dbg sectorlisp.bin

brainfuck.o: brainfuck.S
	$(AS) -g -o $@ $<

brainfuck.bin.dbg: brainfuck.o
	$(LD) -oformat:binary -Ttext=0x7c00 -o $@ $<

brainfuck.bin: brainfuck.bin.dbg
	objcopy -S -O binary brainfuck.bin.dbg brainfuck.bin

%.o: %.js
	$(COMPILE.c) -xc $(OUTPUT_OPTION) $<
