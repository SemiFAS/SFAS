_EXC   := $(DIR_PARSER)/libparser.a
_TEXC  := $(DIR_PARSER)/test.out

_LIB   :=
_ALIB  := $(_LIB)
_T_LIB := $(_LIB) -lcriterion

_DIR_SRC  := $(DIR_PARSER)/src
_DIR_INC  := $(DIR_PARSER)/inc
_DIR_TEST := $(DIR_PARSER)/test
_DIR_UNIT := $(_DIR_TEST)/unit
_DIR_OBJ  := $(DIR_PARSER)/obj

_SRC := $(wildcard $(_DIR_SRC)/*.c)
_INC := $(wildcard $(_DIR_INC)/*.h)

_T_UNIT_SRC := $(wildcard $(_DIR_UNIT)/*.c)

_AOBJ       := $(_SRC:%.c=%.o) $(_DIR_OBJ)/parser_yacc.o $(_DIR_OBJ)/lexer_lex.o
_T_UNIT_OBJ := $(_T_UNIT_SRC:%.c=%_test.o) $(_SRC:%.c=%_test.o) $(_DIR_OBJ)/parser_yacc.o $(_DIR_OBJ)/lexer_lex.o

_INCLUDE    := -I $(_DIR_INC)
_LIB_PATH   :=

_A_INCLUDE  := $(_INCLUDE)
_A_LIB_PATH := $(_LIB_PATH)

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


$(_DIR_OBJ)/lexer_lex.o: $(_DIR_OBJ)/parser_yacc.o
	$(Q)$(MKDIR) $(_DIR_OBJ)
	$(call print_lex,$(_DIR_SRC)/lexer.l)
	$(Q)$(LEX) $(LEX_FLAGS) --header-file=$(_DIR_INC)/lexer_lex.h -o $(_DIR_OBJ)/lexer_lex.c $(_DIR_SRC)/lexer.l
	$(call print_cc,$(_DIR_OBJ)/lexer_lex.c)
	$(Q)$(CC) $(_A_INCLUDE) -c $(_DIR_OBJ)/lexer_lex.c -o $(_DIR_OBJ)/lexer_lex.o


$(_DIR_OBJ)/parser_yacc.o:
	$(Q)$(MKDIR) $(_DIR_OBJ)
	$(call print_yacc,$(_DIR_SRC)/parser.y)
	$(Q)$(YACC) $(YACC_FLAGS) --defines=$(_DIR_INC)/parser_yacc.h -o $(_DIR_OBJ)/parser_yacc.c $(_DIR_SRC)/parser.y
	$(call print_cc,$(_DIR_OBJ)/parser_yacc.c)
	$(Q)$(CC) $(_A_INCLUDE) -c $(_DIR_OBJ)/parser_yacc.c -o $(_DIR_OBJ)/parser_yacc.o


.PHONY:$(_EXC)
$(_EXC): $(_SRC) $(_INC) $(_AOBJ)
	$(call print_ar,$@)
	$(Q)$(AR) $@ $(_AOBJ)


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
	$(Q)$(RM) $(_DIR_INC)/lexer_lex.h
	$(Q)$(RM) $(_DIR_INC)/parser_yacc.h
	$(Q)$(RM) $(_DIR_OBJ)