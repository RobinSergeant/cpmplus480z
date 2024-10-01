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

fds: _fds_config.zsm
	tnylpo-convert -u $< -c config.zsm

mds: _mds_config.zsm
	tnylpo-convert -u $< -c config.zsm

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

test-fds: test_fds.imd ccp.com $(TARGETS)
	cpmrm $^
	cpmcp $^ 0:

test-mds: test_mds.imd ccp.com $(TARGETS)
	cpmrm -f rm-sd $^
	cpmcp -f rm-sd $^ 0:

clean:
	rm -f $(TARGETS) gencpm.dat config.zsm *bios*.rel *bios*.spr coldboot.rel
