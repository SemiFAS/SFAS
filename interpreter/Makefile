_EXC   := interpreter.out
_TEXC  := $(DIR_INTERPRETER)/test.out

_LIB   :=
_ALIB  := $(_LIB) -lglib-2.0
_T_LIB := $(_LIB) -lcriterion

_DIR_SRC  := $(DIR_INTERPRETER)/src
_DIR_INC  := $(DIR_INTERPRETER)/inc
_DIR_APP  := $(DIR_INTERPRETER)/app
_DIR_TEST := $(DIR_INTERPRETER)/test
_DIR_UNIT := $(_DIR_TEST)/unit

_SRC := $(wildcard $(_DIR_SRC)/*.c)
_APP := $(wildcard $(_DIR_APP)/*.c)
_INC := $(wildcard $(_DIR_INC)/*.h)

_T_UNIT_SRC := $(wildcard $(_DIR_UNIT)/*.c)

_AOBJ       := $(_SRC:%.c=%.o) $(_APP:%.c=%.o)
_T_UNIT_OBJ := $(_T_UNIT_SRC:%.c=%_test.o) $(_SRC:%.c=%_test.o)

_INCLUDE    := -I $(_DIR_INC)
_LIB_PATH   :=

_A_INCLUDE  := $(_INCLUDE) -I $(DIR_GNULIB_INC) -I $(DIR_GNULIB_LIB_INC)
_A_LIB_PATH := $(_LIB_PATH) -L $(DIR_GNULIB_LIB) -Wl,-rpath=$(DIR_GNULIB_LIB)

_T_INCLUDE  := $(_INCLUDE) -I $(_DIR_INC) -I $(DIR_CRITERION_INC)
_T_LIB_PATH := $(_LIB_PATH) -L$(DIR_CRITERION_LIB) -Wl,-rpath=$(DIR_CRITERION_LIB)

%.o: %.c $(_INC)
	$(call print_analyze,$<)
	$(Q)$(ANALYZER) $(ANALYZER_FLAGS) $(_A_INCLUDE)  $<
	$(call print_cc,$<)
	$(Q)$(SCAN_BUILD) $(SCAN_BUILD_FLAGS) $(CC) $(CC_FLAGS) $(_A_INCLUDE) -c $< -o $@

%_test.o: %.c $(_INC)
	$(call print_analyze,$<)
	$(Q)$(ANALYZER) $(ANALYZER_FLAGS) $(_T_INCLUDE)  $<
	$(call print_cc,$<)
	$(Q)$(SCAN_BUILD) $(SCAN_BUILD_FLAGS) $(CC) $(CC_TEST_FLAGS) $(_T_INCLUDE) -c $< -o $@

.PHONY:all
all: $(_EXC)


.PHONY:$(_EXC)
$(_EXC): $(_SRC) $(_APP) $(_INC) $(_AOBJ)
	$(call print_bin,$@)
	$(Q)$(CC) $(CC_FLAGS) $(_A_INCLUDE) $(_A_LIB_PATH) $(_AOBJ) $(_ALIB)  -o $@


.PHONY:test
test: $(_T_UNIT_SRC) $(_INC) $(_T_UNIT_OBJ)
	$(call print_bin,$@)
	$(Q)$(CC) $(CC_TEST_FLAGS) $(_T_INCLUDE)  $(_T_LIB_PATH) $(_T_UNIT_OBJ) $(_T_LIB) -o $(_TEXC)


.PHONY:memcheck
memcheck:


.PHONY:run
run:
	$(Q)$(_TEXC)


.PHONY:clean
clean:
	$(Q)$(RM) $(_AOBJ)
	$(Q)$(RM) $(_EXC)
	$(Q)$(RM) $(_TEXC)
	$(Q)$(RM) $(_T_UNIT_OBJ)
