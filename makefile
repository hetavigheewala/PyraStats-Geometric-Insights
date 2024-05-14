
OBJS	= PyraStats.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: PyraStats

PyraStats.o: PyraStats.asm 
	$(ASM) PyraStats.asm -l PyraStats.lst

PyraStats: PyraStats.o
	$(LD) -o PyraStats $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm	PyraStats.lst
