TARGETS = bios3.rel ldrbios.rel scb.rel \
          coldboot.com install.com

%.zsm : _%.zsm
	tnylpo-convert -u $< -c $@

%.rel : %.zsm
	tnylpo zasm.com $*.aaa

%.com : %.zsm
	tnylpo zasm.com $*.aaa

all: $(TARGETS)
