_EXC := interpreter.out
_LIB :=

_TEXC := $(DIR_INTERPRETER)/test.out

_DIR_SRC  := $(DIR_INTERPRETER)/src
_DIR_INC  := $(DIR_INTERPRETER)/inc
_DIR_APP  := $(DIR_INTERPRETER)/app
_DIR_TEST := $(DIR_INTERPRETER)/test
_DIR_UNIT := $(_DIR_TEST)/unit

_SRC := $(wildcard $(_DIR_SRC)/*.c)
_APP := $(wildcard $(_DIR_APP)/*.c)

_INC := $(wildcard $(_DIR_SRC)/*.h)

_T_UNIT_SRC := $(wildcard $(_DIR_UNIT)/*.c)

_AOBJ := $(_SRC:%.c=%.o) $(_APP:%.c=%.o)
_T_UNIT_OBJ := $(_T_UNIT_SRC:%.c=%_test.o) $(_SRC:%.c=%_test.o)

%.o: %.c $(_INC)
	$(call print_cc,$<)
	$(Q)$(CC) $(CC_FLAGS) -I $(_DIR_INC) -c $< -o $@

%_test.o: %.c $(_INC)
	$(call print_cc,$<)
	$(Q)$(CC) $(CC__TEST_FLAGS) -I $(_DIR_INC) -I $(DIR_CRITERION_INC) -c $< -o $@

.PHONY:all
all: $(_EXC)


.PHONY:$(_EXC)
$(_EXC): $(_SRC) $(_APP) $(_INC) $(_AOBJ)
	$(call print_bin,$@)
	$(Q)$(CC) $(CC_FLAGS) -I$(_DIR_INC) $(_AOBJ) $(_LIB) -o $@


.PHONY:test
test: $(_T_UNIT_SRC) $(_INC) $(_T_UNIT_OBJ)
	$(call print_bin,$@)
	$(Q)$(CC) $(CC_TEST_FLAGS) -I $(_DIR_INC) -I $(DIR_CRITERION_INC) $(_LIB) -L$(DIR_CRITERION_LIB) $(_T_UNIT_OBJ) -lcriterion -Wl,-rpath=$(DIR_CRITERION_LIB) -o $(_TEXC)


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
