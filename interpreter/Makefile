_EXC := interpreter.out
_LIB :=

_DIR_SRC := $(DIR_INTERPRETER)/src
_DIR_INC := $(DIR_INTERPRETER)/inc
_DIR_APP := $(DIR_INTERPRETER)/app

_SRC := $(wildcard $(_DIR_SRC)/*.c)
_APP := $(wildcard $(_DIR_APP)/*.c)

_INC := $(wildcard $(_DIR_SRC)/*.h)

_AOBJ := $(_SRC:%.c=%.o) $(_APP:%.c=%.o)

%.o: %.c $(_INC)
	$(call print_cc,$<)
	$(Q)$(CC) $(CC_FLAGS) -I $(_DIR_INC) -c $< -o $@

.PHONY:all
all: $(_EXC)


.PHONY:$(_EXC)
$(_EXC): $(_SRC) $(_APP) $(_INC) $(_AOBJ)
	$(call print_bin,$@)
	$(Q)$(CC) $(CC_FLAGS) -I$(_DIR_INC) $(_AOBJ) $(_LIB) -o $@


.PHONY:test
test:


.PHONY:memcheck
memcheck: test


.PHONY:run
run: test


.PHONY:clean
clean:
	$(Q)$(RM) $(_AOBJ)
	$(Q)$(RM) $(_EXC)
