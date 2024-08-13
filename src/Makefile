TARGETS = cpmldr.com \
          coldboot.com \
	  install.com \
	  cpm3.sys

all: $(TARGETS)

%.zsm : _%.zsm
	tnylpo-convert -u $< -c $@

% : _%
	tnylpo-convert -u $< -c $@

%.rel : %.zsm
	tnylpo zasm $*.aaa

%.com : %.zsm
	tnylpo zasm $*.aaa

cpmldr.com : cpmldr.rel ldrbios.rel
	cpm link cpmldr,ldrbios

bios3.spr : bios3.rel scb.rel
	cpm link bios3[os]=bios3,scb

cpm3.sys : bios3.spr bdos3.spr gencpm.dat
	tnylpo gencpm auto

install: test.imd ccp.com $(TARGETS)
	cpmrm -f rm-dd $^
	cpmcp -f rm-dd $^ 0:

clean:
	rm $(TARGETS)
