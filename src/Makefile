TARGETS = cpmldr.com \
          coldboot.com \
          install.com \
          copysys.com \
          cpm3.sys

all: $(TARGETS)

%.zsm : _%.zsm
	tnylpo-convert -u $< -c $@

%.rel : %.zsm
	tnylpo zasm $*.aaa

%.com : %.zsm
	tnylpo zasm $*.aaa

banked: gencpm_banked.dat
	tnylpo-convert -u $< -c gencpm.dat

nonbanked: gencpm_nonbanked.dat
	tnylpo-convert -u $< -c gencpm.dat

cpmldr.com : cpmldr.rel ldrbios.rel
	tnylpo link cpmldr,ldrbios

coldboot.com : coldboot.rel
	tnylpo link coldboot[L80]

bios3.spr : bios3.rel scb.rel
	tnylpo link bios3[os]=bios3,scb

bnkbios3.spr : bnkbios3.rel scb.rel
	tnylpo link bnkbios3[b]=bnkbios3,scb

cpm3.sys : bios3.spr bnkbios3.spr bdos3.spr bnkbdos3.spr resbdos3.spr gencpm.dat
	tnylpo gencpm auto

test: test.imd ccp.com $(TARGETS)
	cpmrm -f rm-dd $^
	cpmcp -f rm-dd $^ 0:

%.zip: ccp.com $(TARGETS)
	zip $@ $^

clean:
	rm $(TARGETS) gencpm.dat *bios*.rel *bios*.spr coldboot.rel
