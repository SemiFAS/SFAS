# SFAS
Semi Functional Architecture Simulator

## OS ##
This project is compatible only with Linux.

## Project Structure ##

#### Common rule ####
+ **inc** - directory for component header files (.h)
+ **src** - directory for component source files (.c)
+ **test** - directory for component tests files (.c)
    + **unit** - directory for unit tests (single function) [criterion]
    + **functional** - directory for functional tests (part of system) [criterion]
    + **e2e** - directory for end to end tests (whole binary file) [shell]
+ **app** - directory for main file (.c) if component should be built as app (.out)

#### arch ####
This directory contains all files about architecture configs and common architecture functionality.

#### docs ####
This directory contains all pdf files which describes architecture and code (doxygen).

#### interpreter ####
This directory contains files related with interpreter (implemented as full functional simulator).

#### parser ####
This directory contains files related with ARM assembler gramma (parser, lexer, tokens).

#### scripts ####
This directory contains files related with all scripts (bash) in this project.

#### simulator ####
This directory contains files related with semi functional architecture simulator.

#### submodules ####
This directory contains files related with all submodules for this project (3th part open source code).

#### utils ####
This directory contains all libraries, common headers ... which means this directory contains code which can be used by any other component.

## Build System ##
To build applications type **make**

To build and run tests type **make test**

To build and run full regressions tests type **make regression**

To remove all object and exec files type **make clean**

To collect more informations about build system type **make help**