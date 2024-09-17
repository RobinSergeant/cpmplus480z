TARGETS = cpmldr.com \
          coldboot.com \
          install.com \
          cpm3.sys

all: $(TARGETS)

%.zsm : _%.zsm
	tnylpo-convert -u $< -c $@

%.rel : %.zsm
	tnylpo zasm $*.aaa

%.com : %.zsm
	tnylpo zasm $*.aaa

gencpm.dat: gencpm_nonbanked.dat
	tnylpo-convert -u $< -c gencpm.dat

cpmldr.com : cpmldr.rel ldrbios.rel
	tnylpo link cpmldr,ldrbios

coldboot.com : coldboot.rel
	tnylpo link coldboot[L80]

bios3.spr : bios3.rel scb.rel
	tnylpo link bios3[os]=bios3,scb

cpm3.sys : bios3.spr bdos3.spr gencpm.dat
	tnylpo gencpm auto

install: test.imd ccp.com $(TARGETS)
	cpmrm $^
	cpmcp $^ 0:

clean:
	rm $(TARGETS) gencpm.dat *bios*.rel *bios*.spr coldboot.rel
