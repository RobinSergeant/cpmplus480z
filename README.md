# cpmplus480z

This project brings CP/M Plus (or CP/M Version 3.0) to the Research Machines 480Z and 380Z computers, which were originally supplied with CP/M 2.2.  I have written both banked and non banked versions of the BIOS from scratch in Z80 assembly language, which when linked with the original Digital Research BDOS produces a working OS.  The banked version requires additional memory (at least 96K), but provides more memory for resident programs (53K rather than 47K) and includes additional operating system features such as password protection for files and more helpful error messages.

![Alt text](/.screenshots/sign_on.png?raw=true)

## Project status

Now fully working and available in four versions:
- A banked 480Z version requiring 256K of RAM (160K of which is used to provide a drive M: silicon disk).
- A non banked 480Z version requiring 64K of RAM.
- A non banked 380Z version for MDS systems (with 5.25" floppy drives).
- A non banked 380Z version for FDS system (with 8" floppy drives).

Both 480Z versions can use single, double, or quad density floppy disks, but a DD or QD floppy is required to boot.  The 380Z version only supports SD.  A custom version of the COPYSYS utility is provided to copy the OS to new floppy disks, and this can handle different densities (e.g. copying from DD to QD).

NB Only the console device is supported and no support is provided for modems or printers.

Tested using MAME with my unreleased 480Z driver (https://github.com/mamedev/mame/pull/12576) and the existing 380Z driver.

## Design notes

- The 480Z floppy disc format reserves 3 tracks for the operating system and these are used as follows:
  - Track 0 contains my cold boot loader which is responsible for running the actual CP/M loader.
  - Track 1 contains the CP/M loader written by Digital Research (linked against a cut down version of my nonbanked BIOS) which is responsible for loading CPM3.SYS and starting the OS.
  - Track 2 contains CCP.COM (the Console Command Processor) written by Digital Research, which is loaded by my BIOS in the cold boot routine.
- For 380Z floppy discs sectors are used sequentially as limited space is availble, i.e. the CP/M loader starts at track 0, sector 2.
- On the 480Z the CCP is initially loaded from disc and then copied to an area of RAM normally hidden by ROM (at 0xE800), so that it can quickly be restored during a warm boot (which occurs whenever a program returns to CP/M).  To access this area the memory layout is switched to all RAM (Page 3) after first disabling interrupts.  A simple checksum is used to trigger a reload from disc if this memory has been changed by another program, e.g. the front panel debugger also makes use of this hidden memory area.
- The 380Z version always reloads the CCP from disc during a warm boot.
- In the banked bios the lower 32K address space is banked and the upper 32K is common.
- BANK0 is the system bank only accessible by the BDOS and BIOS.  This is stored in expansion ram (using two 16K blocks - blocks 4 and 5).
- BANK1 is the TPA bank that running programs see.  This is stored in normal RAM (blocks 1 and 2).
- When the BIOS needs to call Firmware routines BANK1 is selected and interrupts are enabled as the Firmware expects this layout.
- Whenever BANK0 is active interrupts are disabled to prevent the Firmware interfering with the memory layout.
- A buffer in common memory is used whenever data needs to be transferred between banks.
- The 480Z banked version includes a silicon disk with 10 x 16K tracks (128 sectors per track).

## Tools

All code is assembled and linked using original CP/M tools available in 1983!

- The Research Machine's assembler (`zasm.com`) is used to produce .REL (relocatable object) and .COM (executable) files from Z80 assembler source.
- The Digital Research linker (`link.com`) is used to produce .SPR (System Page Relocatable) object files from .REL files.
- Finally GENCCPM (`gencpm.com`) is used to combine the BDOS and BIOS .SPR files into CPM3.SYS, thus generating the operating system.

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

Make can be used to build everything under Linux (using the above mentioned tools).

To build the 480Z versions use `make banked` or `make nonbanked` to produce the desired GENCPM config file.  After this settings that effect the generation of CPM3.SYS can be tweaked further by running GENCPM manually to override the defaults I have chosen.  Then use`make all` to generate all the required target files and `make test` to copy these to a disc image file named test.imd (this blank IMD disc image must already exist).

To build the 380Z version run `make mds all` or `make fds all` depending on the desired floppy drive configuration.

## Installation instructions

On the 480Z (or 380Z) run install.com under CP/M 2.2 to write the system tracks and reboot to start CP/M Plus!

The standard set of CP/M utilities provided by DR can be freely obtained online (http://www.cpm.z80.de/binary.html).  Copy all required utilities to your new system disk, e.g. pip.com etc.

## References

The original system guide explains how to construct a new BIOS and produce the OS, and this is what I followed:

[CP/M Plus System Guide](http://www.cpm.z80.de/manuals/cpm3-sys.pdf)

Details about the 480Z and it's firmware are given by these documents:

[480Z Information File](https://vt100.net/rm/docs/pn10939.pdf)

[380Z and 480Z Firmware Reference Manual](https://vt100.net/rm/docs/pn10971.pdf)
