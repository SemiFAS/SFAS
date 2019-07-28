# Main Makefile
# Author: Michal Kukowski
# email: michalkukowski10@gmail.com

# Targets:
# help       - print targets (visible for user) + parameters
# clean      - removing object end exec files
# test       - make static tests
# all[D=1]   - make all applications when D == 1 then target will be build in Debug mode
# memcheck   - make memcheck using valgrind for all tests
# regression - make clean + test + memcheck
# setup      - install tools
# Makefile supports Verbose mode, put V=1 after target name to set verbose mode

export

# Shell

MV    := mv
RM    := rm -rf
CP    := cp 2>/dev/null
AR    := ar rcs
WC    := wc
BC    := bc
GREP  := grep -q
AWK   := awk
MKDIR := mkdir -p

# Analyzer settings
ANALYZER         := clang --analyze
ANALYZER_FLAGS   := --analyzer-output text

SCAN_BUILD       := scan-build >/dev/null
SCAN_BUILD_FLAGS := --status-bugs --keep-cc --show-description

# Compiler settings
CC          ?= clang

CC_STD      := -std=c99
CC_OPT      := -O3
CC_WARNINGS := -Wall -Wextra -pedantic -Wcast-align \
               -Winit-self -Wmissing-include-dirs \
               -Wredundant-decls -Wshadow -Wstrict-overflow=5 -Wundef  \
               -Wwrite-strings -Wpointer-arith -Wmissing-declarations \
               -Wuninitialized -Wold-style-definition -Wstrict-prototypes \
               -Wmissing-prototypes -Wswitch-default -Wbad-function-cast \
               -Wnested-externs -Wconversion -Wunreachable-code \


ifeq ($(CC),gcc)
CC_SYM      := -rdynamic
else ifeq ($(CC),clang)
CC_SYM      := -Wl,--export-dynamic
CC_WARNINGS += -Wgnu -Weverything -Wno-unused-command-line-argument -Wno-newline-eof -Wno-reserved-id-macro \
               -Wno-documentation -Wno-documentation-unknown-command -Wno-padded
endif

CC_FLAGS      := $(CC_STD) $(CC_WARNINGS) -Werror $(CC_OPT) $(CC_SYM)
CC_TEST_FLAGS := $(CC_STD) -Wall -Wextra -pedantic $(CC_OPT) $(CC_SYM)

# LEX settings
LEX       := flex
LEX_FLAGS := -F --yylineno

# YACC settings
YACC       := bison
YACC_FLAGS :=

PROJECT_DIR := $(shell pwd)

# Global directories

DIR_ARCH           := $(PROJECT_DIR)/arch
DIR_INTERPRETER    := $(PROJECT_DIR)/interpreter
DIR_PARSER         := $(PROJECT_DIR)/parser
DIR_SIMULATOR      := $(PROJECT_DIR)/simulator
DIR_UTILS          := $(PROJECT_DIR)/utils

DIR_SCRIPTS        := $(PROJECT_DIR)/scripts
DIR_SUBMODULES     := $(PROJECT_DIR)/submodules
DIR_EXTERNAL       := $(PROJECT_DIR)/external

DIR_CRITERION      := $(DIR_EXTERNAL)/criterion
DIR_CRITERION_LIB  := $(DIR_CRITERION)/
DIR_CRITERION_INC  := $(DIR_CRITERION)/include

DIR_GNULIB         := $(DIR_EXTERNAL)/gnulib
DIR_GNULIB_LIB     := $(DIR_GNULIB)/lib/x86_64-linux-gnu
DIR_GNULIB_INC     := $(DIR_GNULIB)/include/glib-2.0
DIR_GNULIB_LIB_INC := $(DIR_GNULIB_LIB)/glib-2.0/include

# Verbose mode
ifeq ("$(origin V)", "command line")
    VERBOSE = $(V)
endif

ifndef VERBOSE
    VERBOSE = 0
endif

ifeq ($(VERBOSE),1)
    Q =
else
    Q = @
endif

# DEBUG MODE
ifeq ("$(origin D)", "command line")
    CC_FLAGS += -ggdb
endif

# Print functions
define print_info
    $(if $(Q), @echo "$(1)")
endef

define print_make
    $(if $(Q), @echo "[MAKE]        $(1)")
endef

define print_cc
    $(if $(Q), @echo "[CC]          $$(1)")
endef

define print_analyze
    $(if $(Q), @echo "[ANALYZE]     $$(1)")
endef

define print_bin
    $(if $(Q), @echo "[BIN]         $$(1)")
endef

define print_ar
    $(if $(Q), @echo "[AR]          $$(1)")
endef

define print_lex
    $(if $(Q), @echo "[LEX]         $$(1)")
endef

define print_yacc
    $(if $(Q), @echo "[YACC]        $$(1)")
endef

.PHONY: all
all: setup interpreter simulator

.PHONY:parser
parser:
	$(call print_make,$@)
	$(Q)$(MAKE) -f $(DIR_PARSER)/Makefile --no-print-directory

.PHONY:interpreter
interpreter: parser
	$(call print_make,$@)
	$(Q)$(MAKE) -f $(DIR_INTERPRETER)/Makefile --no-print-directory

.PHONY:simulator
simulator: parser
	$(call print_make,$@)
	$(Q)$(MAKE) -f $(DIR_SIMULATOR)/Makefile --no-print-directory

.PHONY:test
test:
	$(call print_make,$@)
	$(Q)$(MAKE) -f $(DIR_UTILS)/Makefile test --no-print-directory
	$(Q)$(MAKE) -f $(DIR_ARCH)/Makefile test --no-print-directory
	$(Q)$(MAKE) -f $(DIR_PARSER)/Makefile test --no-print-directory
	$(Q)$(MAKE) -f $(DIR_INTERPRETER)/Makefile test --no-print-directory
	$(Q)$(MAKE) -f $(DIR_SIMULATOR)/Makefile test --no-print-directory
	$(Q)$(MAKE) -f $(DIR_UTILS)/Makefile run --no-print-directory
	$(Q)$(MAKE) -f $(DIR_ARCH)/Makefile run --no-print-directory
	$(Q)$(MAKE) -f $(DIR_PARSER)/Makefile run --no-print-directory
	$(Q)$(MAKE) -f $(DIR_INTERPRETER)/Makefile run --no-print-directory
	$(Q)$(MAKE) -f $(DIR_SIMULATOR)/Makefile run --no-print-directory


.PHONY:memcheck
memcheck:
	$(call print_make,$@)
	$(Q)$(MAKE) -f $(DIR_UTILS)/Makefile test --no-print-directory
	$(Q)$(MAKE) -f $(DIR_ARCH)/Makefile test --no-print-directory
	$(Q)$(MAKE) -f $(DIR_PARSER)/Makefile test --no-print-directory
	$(Q)$(MAKE) -f $(DIR_INTERPRETER)/Makefile test --no-print-directory
	$(Q)$(MAKE) -f $(DIR_SIMULATOR)/Makefile test --no-print-directory
	$(Q)$(MAKE) -f $(DIR_UTILS)/Makefile memcheck --no-print-directory
	$(Q)$(MAKE) -f $(DIR_ARCH)/Makefile memcheck --no-print-directory
	$(Q)$(MAKE) -f $(DIR_PARSER)/Makefile memcheck --no-print-directory
	$(Q)$(MAKE) -f $(DIR_INTERPRETER)/Makefile memcheck --no-print-directory
	$(Q)$(MAKE) -f $(DIR_SIMULATOR)/Makefile memcheck --no-print-directory

.PHONY:clean
clean:
	$(call print_make,$@)
	$(Q)$(MAKE) -f $(DIR_UTILS)/Makefile clean --no-print-directory
	$(Q)$(MAKE) -f $(DIR_ARCH)/Makefile clean --no-print-directory
	$(Q)$(MAKE) -f $(DIR_PARSER)/Makefile clean --no-print-directory
	$(Q)$(MAKE) -f $(DIR_INTERPRETER)/Makefile clean --no-print-directory
	$(Q)$(MAKE) -f $(DIR_SIMULATOR)/Makefile clean --no-print-directory

.PHONY:regression
regression: clean all test memcheck

.PHONY:setup
setup:
	$(call print_info,"Setting env")
	$(Q)env -i HOME=${HOME} bash -l -c '$(DIR_SCRIPTS)/setup.sh'

.PHONY:help
help:
	@echo "Main Makefile"
	@echo -e
	@echo "Targets:"
	@echo "    all[D=1]          - build applications, D=1 --> debug mode"
	@echo "    clean             - removing object and exec files"
	@echo "    test              - make static tests"
	@echo "    memcheck          - make mem check using valgrind for tests"
	@echo "    regression        - regression tests use it before commit to master"
	@echo "    setup             - setup env"
	@echo -e
	@echo "Makefile supports Verbose mode when V=1"