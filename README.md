Docker-based Kaleidoscope firmware builder
==========================================

This is a fairly simplistic tool that helps building a Kaleidoscope-based firmware in Docker. This allows one to skip installing a build environment, with all bells and whistles set up. Once built, the output is a complied `.hex` file which one can then flash.

Eventually, this repository will provide tools for flashing too.

## Usage

Run `bin/builder -s /path/to/your/sketch/`, and wait. Output will - by default - appear in an `output/` directory.
