%{

/* include section here */

static void yyerror(const char *msg);
static int yyparse(void);
%}

%code requires
{
    /* includes, extern etc needed to generate output */
    extern int yylex(void);
}

/* override yylval using %union { } */

/* tokens definision here by %token */

/* gramma definision below */
%%

code:
	%empty

%%

/* functions here */
static void yyerror(const char *msg)
{
    (void)msg;
}