Docker-based Kaleidoscope firmware builder
==========================================

This is a fairly simplistic tool that helps building a Kaleidoscope-based
firmware in Docker. This allows one to skip installing a build environment, with
all bells and whistles set up. Once built, the output is a complied `.hex` file
which one can then flash, using the included helper tool.

## Usage

For now, run `bin/builder` and `bin/flasher` without arguments, and they'll
display their documentation.
