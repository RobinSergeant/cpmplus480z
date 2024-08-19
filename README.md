# cpmplus480z

This project brings CP/M Plus (or CP/M Version 3.0) to the Research Machines 480Z computer, which was originally supplied with CP/M 2.2.  I have written both banked and non banked versions of the BIOS from scratch in Z80 assembly language, which when linked with the original Digital Research BDOS produces a working OS.  The banked version requires additional memory (at least 96K), but provides more memory for resident programs (53K rather than 47K) and includes addtional operating system features such as password protection for files and more helpeful error messages.

## Project status

The project is still at an early beta release stage, but basic functionality has been sucesfully tested under emulation using the unreleased 480Z MAME driver that I have also written (https://github.com/mamedev/mame/pull/12576).

## Tools

All code is assembled and linked using original CP/M tools available in 1983!

- The Research Machine's assembler (`zasm.com`) is used to produce .REL (relocatable object) and .COM (executable) files from Z80 assembler source.
- The Digital Research linker (`link.com`) is used to produce .SPR (System Page Relocatable) object files from .REL files.
- Finally GENCCPM (`gencpm.com`) is used to conmbine the BDOS and BIOS .SPR files into CPM3.SYS, thus generating the operating system.

To speed up the development process these tools are executed under Linux using the [tnylpo](https://gitlab.com/gbrein/tnylpo) command line CP/M emulator.

## Other required files

The following third party (Digital Research) CP/M binary files are required:

- ccp.com
- cpmldr.rel
- bdos3.spr
- bnkbdos3.spr
- resbdos3.spr

As CP/M is now open source these can be freely obtained (http://www.cpm.z80.de/binary.html).

## Source code

My .zsm source files are prefixed with an underscore to indicate that they are in UNIX text file format.  To be understood by CP/M tools they must be converted to CP/M text file format, which can be done using `tnylpo-convert`.

## Build instructions

Make can be used bo build everything form Linux (using the above mentioned tools).

Use `make banked` or `make nonbanked` to produce the desired GENCPM config file.  After this settings that effect the generation of CPM3.SYS can be tweaked further by running GENCPM manually to override the defaults I have chosen.

Use `make all` to generate all the required target files and `make install` to copy these to a disc image file named test.imd (this blank IMD disc image must already exist).

## Installation instructions

On the 480Z run install.com under CP/M 2.2 to write the system tracks and reboot to start CP/M Plus!

## Refererences

The original system guide explains how to contruct a new BIOS and produce the OS, and this is what I followed:

[CP/M Plus System Guide](http://www.cpm.z80.de/manuals/cpm3-sys.pdf)

Details about the 480Z and it's firmware are given by these documents:

[480Z Information File](https://vt100.net/rm/docs/pn10939.pdf)

[380Z and 480Z Firmware Reference Manual](https://vt100.net/rm/docs/pn10971.pdf)
