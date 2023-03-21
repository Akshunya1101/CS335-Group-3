%{
    #include<bits/stdc++.h>
#include "parser.tab.h"
using namespace std;
%}

%option yylineno

LT          \<

GT          \>

SUPER       super

KEYWORD     goto|const

CONTINUE    continue

FOR         for

SWITCH      switch

ASSERT      assert

IF          if

PACKAGE     package

SYNCHRONIZED synchronized

BOOLEAN     boolean

DO          do

BREAK       break

DOUBLE      double

THROW       throw

BYTE        byte

ELSE        else

IMPORT      import

CASE        case

ENUM        enum

RETURN      return

TRANSIENT   transient

CATCH       catch

INT         int 

SHORT       short

TRY         try

CHAR        char

LONG        long

FINALLY     finally

VOLATILE    volatile

FLOAT       float

WHILE       while

NATIVE      native

EXPORTS     exports

OPENS       opens

REQUIRES    requires

USES        uses

MODULE      module

PROVIDES    provides

TO          to

WITH        with

OPEN        open

TRANSITIVE  transitive

EXTENDS     extends

INTERFACE   interface

THROWS      throws

VOID        void

NOT         \!

TILDE       \~

INC         \+\+

DEC         \-\-

PLUS        \+

MINUS       \-

MULT        \*

DIV         \/

MOD         \%

SHIFTER     \<\<|\>\>|\>\>\>

EQNQ        \=\=|\!\=

AND         \&

INSTANCEOF  instanceof

NEW         new

THIS        this

XOR         \^

OR          \|

BOOL_AND    \&\&

TWO_COL   \:\:

SEMICOL     \;

LSB         \[

RSB         \]

THREED      \.\.\.

ARROW       \-\>

COMMA       \,

COL         \:

QM          \?

LB          \(

LCB         \{

RCB         \}

RB          \)

EQ          \=

EQQ         \*\=|\/\=|\%\=|\+\=|\-\=|\<\<\=|\>\>\=|\>\>\>\=|\&\=|\|\=|\^\= 

DOT             \.

AT_THE_RATE     \@

BOOL_OR         \|\|

RELOP           \>\=|\<\=

PUBLIC          public

DEFAULT         default

PROTECTED       protected

PRIVATE         private

ABSTRACT        abstract

STATIC          static

SEALED          sealed

NON_SEALED      non-sealed

STRICTFP        strictfp

LETTER          [a-zA-Z\$\_]    
DIGIT           [0-9]
HEX_DIGIT       [0-9a-fA-F]
OCT_DIGIT       [0-7]
BIN_DIGIT       [01]


DIGITS          {DIGIT}|{DIGIT}({DIGIT}|\_)*{DIGIT}
DECIMAL_NUM     0|[1-9]({DIGITS}?|\_+{DIGITS})


HEX_DIGITS      {HEX_DIGIT}|{HEX_DIGIT}({HEX_DIGIT}|\_)*{HEX_DIGIT}
HEX_NUM         0[Xx]{HEX_DIGITS}


OCT_DIGITS      {OCT_DIGIT}|{OCT_DIGIT}({OCT_DIGIT}|\_)*{OCT_DIGIT}
OCT_NUM         0(\_)*{OCT_DIGITS}

BIN_DIGITS      {BIN_DIGIT}|{BIN_DIGIT}({BIN_DIGIT}|\_)*{BIN_DIGIT}
BIN_NUM         0[bB]{BIN_DIGITS}

INT_LITERAL     ({DECIMAL_NUM}|{HEX_NUM}|{OCT_NUM}|{BIN_NUM})[lL]?


DECIMAL_FLOAT_LITERAL   ({DIGITS}\.{DIGITS}?|\.{DIGITS})([eE][+-]?{DIGITS})?[fFdD]?|{DIGITS}(([eE][+-]?{DIGITS})[fFdD]?|([eE][+-]?{DIGITS})?[fFdD])
HEX_FLOAT_LITERAL       ({HEX_NUM}(\.)?|0[Xx]{HEX_DIGITS}?\.{HEX_DIGITS})[pP][+-]?{DIGITS}[fFdD]?
FLOAT_LITERAL           {DECIMAL_FLOAT_LITERAL}|{HEX_FLOAT_LITERAL}

BOOL_LITERAL            true|false

SINGLE_CHAR              [^\'\n\r\\]

CHAR_LITERAL             \'{SINGLE_CHAR}\'|\'(\\[btnfrs\"\\])\'

STRING_LITERAL           \"(\\[btnfrs\"\\]|[^\"\\])*\"

TB                       \"\"\"[ \t\f]*[\n\r](.|[^\"\"\"])*\"\"\"

NULL_LITERAL             null

IDENTIFIER               {LETTER}({LETTER}|{DIGIT})*

RECORD                   record

PERMITS                  permits

VAR                      var

FINAL                    final

CLASS                    class

IMPLEMENTS               implements

OVERRIDE                 Override

%%
\/\*([^\*]|\*+[^\/])*\*\/|\/\/[^\n\r]* {}
[ \t\f\n]+ {}
{INT_LITERAL} {yylval.s.str = strdup(yytext); yylval.s.var = strdup(yytext);
              return Int_Literal;}
{FLOAT_LITERAL} {yylval.s.str = strdup(yytext); yylval.s.var = strdup(yytext);
              return Float_Literal;}
{BOOL_LITERAL} {yylval.s.str = strdup(yytext); yylval.s.var = strdup(yytext);
              return Bool_Literal;}
{CHAR_LITERAL} {yylval.s.str = strdup(yytext); yylval.s.var = strdup(yytext);
              return Char_Literal;}
{TB} {yylval.s.str = strdup(yytext); yylval.s.var = strdup(yytext);
              return Tb;}
{NULL_LITERAL} {yylval.s.str = strdup(yytext); yylval.s.var = strdup(yytext);
              return Null_Literal;}
{STRING_LITERAL} {yylval.s.str = strdup(yytext);
              return String_Literal;}
{RECORD} {yylval.s.str = strdup(yytext);
              return Record;}
{OVERRIDE} {yylval.s.str = strdup(yytext);
              return Override;}
{PERMITS} {yylval.s.str = strdup(yytext);
              return Permits;}
{VAR} {yylval.s.str = strdup(yytext);
              return Var;}
{FINAL} {yylval.s.str = strdup(yytext);
              return Final;}
{CLASS} {yylval.s.str = strdup(yytext);
              return Class;}
{IMPLEMENTS} {yylval.s.str = strdup(yytext);
              return Implements;}
{SHIFTER} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Shifter;}
{EQQ} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return  Eqq;}
{BOOL_OR} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Bool_or;}
{BOOL_AND} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Bool_and;}
{RELOP} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Relop;}
{LT} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Lt;}
{GT} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Gt;}
{SUPER} {yylval.s.str = strdup(yytext);
              return  Super;}
{KEYWORD} {return  Keyword;}
{CONTINUE} {yylval.s.str = strdup(yytext);
              return Continue;}
{FOR} {yylval.s.str = strdup(yytext);
              return For;}
{SWITCH} {yylval.s.str = strdup(yytext);
              return Switch;}
{ASSERT} {yylval.s.str = strdup(yytext);
              return Assert;}
{IF} {yylval.s.str = strdup(yytext);
              return If;}
{PACKAGE} {yylval.s.str = strdup(yytext);
              return Package;}
{SYNCHRONIZED} {yylval.s.str = strdup(yytext);
              return Synchronized;}
{BOOLEAN} {yylval.s.str = strdup(yytext);
              return Bboolean;}
{DO} {yylval.s.str = strdup(yytext);
              return Do;}
{BREAK} {yylval.s.str = strdup(yytext);
              return Break;}
{DOUBLE} {yylval.s.str = strdup(yytext);
              return Double;}
{THROW} {yylval.s.str = strdup(yytext);
              return Throw;}
{BYTE} {yylval.s.str = strdup(yytext);
              return Bbyte;}
{ELSE} {yylval.s.str = strdup(yytext);
              return Else;}
{IMPORT} {yylval.s.str = strdup(yytext);
              return Import;}
{CASE} {yylval.s.str = strdup(yytext);
              return Case;}
{ENUM} {yylval.s.str = strdup(yytext);
              return Enum;}
{RETURN} {yylval.s.str = strdup(yytext);
              return Return;}
{TRANSIENT} {yylval.s.str = strdup(yytext);
              return Transient;}
{CATCH} {yylval.s.str = strdup(yytext);
              return Catch;}
{INT} {yylval.s.str = strdup(yytext);
              return Int;}
{SHORT} {yylval.s.str = strdup(yytext);
              return Short;}
{TRY} {yylval.s.str = strdup(yytext);
              return Try;}
{CHAR} {yylval.s.str = strdup(yytext);
              return Char;}
{LONG} {yylval.s.str = strdup(yytext);
              return Long;}
{FINALLY} {yylval.s.str = strdup(yytext);
              return finally;}
{VOLATILE} {yylval.s.str = strdup(yytext);
              return Volatile;}
{FLOAT} {yylval.s.str = strdup(yytext);
              return Float;}
{WHILE} {yylval.s.str = strdup(yytext);
              return While;}
{NATIVE} {yylval.s.str = strdup(yytext);
              return Native;}
{EXPORTS} {yylval.s.str = strdup(yytext);
              return Exports;}
{OPENS} {yylval.s.str = strdup(yytext);
              return Opens;}
{REQUIRES} {yylval.s.str = strdup(yytext);
              return Requires;}
{USES} {yylval.s.str = strdup(yytext);
              return Uses;}
{MODULE} {yylval.s.str = strdup(yytext);
              return Module;}
{PROVIDES} {yylval.s.str = strdup(yytext);
              return Provides;}
{TO} {yylval.s.str = strdup(yytext);
              return To;}
{WITH} {yylval.s.str = strdup(yytext);
              return With;}
{OPEN} {yylval.s.str = strdup(yytext);
              return Open;}
{TRANSITIVE} {yylval.s.str = strdup(yytext);
              return Transitive;}
{EXTENDS} {yylval.s.str = strdup(yytext);
              return Extends;}
{INTERFACE} {yylval.s.str = strdup(yytext);
              return Interface;}
{THROWS} {yylval.s.str = strdup(yytext);
              return throws;}
{VOID} {yylval.s.str = strdup(yytext);
              return Void;}
{EQNQ} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Eqnq;}
{NOT} {yylval.s.str = strdup(yytext);
              return Not;}
{TILDE} {yylval.s.str = strdup(yytext);
              return Tilde;}
{INC} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Inc;}
{DEC} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Dec;}
{PLUS} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Plus;}
{MINUS} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Minus;}
{MULT} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Mult;}
{DIV} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Div;}
{MOD} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Mod;}
{AND} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return And;}
{INSTANCEOF} {yylval.s.str = strdup(yytext);
              return Instanceof;}
{NEW} {yylval.s.str = strdup(yytext);
              return  New;}
{THIS} {yylval.s.str = strdup(yytext);
              return This;}
{XOR} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return Xor;}
{OR} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return  Or;}
{TWO_COL} {yylval.s.str = strdup(yytext);
              return Two_col;}
{SEMICOL} {yylval.s.str = strdup(yytext);
              return  Semicol;}
{LSB} {yylval.s.str = strdup(yytext);
              return  Lsb;}
{RSB} {yylval.s.str = strdup(yytext);
              return  Rsb;}
{THREED} {yylval.s.str = strdup(yytext);
              return  Threed;}
{ARROW} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return  Arrow;}
{COMMA} {yylval.s.str = strdup(yytext);
              return  Comma;}
{COL} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return  Col;}
{QM} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return  Qm;}
{LB} {yylval.s.str = strdup(yytext);
              return  Lb;}
{LCB} {yylval.s.str = strdup(yytext);
              return  Lcb;}
{RCB} {yylval.s.str = strdup(yytext);
              return  Rcb;}
{RB} {yylval.s.str = strdup(yytext);
              return  Rb;}
{EQ} {yylval.s.num = -1; yylval.s.str = strdup(yytext);
              return  Eq;}
{DOT} {yylval.s.str = strdup(yytext);
              return  Dot;}
{AT_THE_RATE} {yylval.s.str = strdup(yytext);
              return Atr;}
{PUBLIC} {yylval.s.str = strdup(yytext);
              return Public;}
{DEFAULT} {yylval.s.str = strdup(yytext);
              return Default;}
{PROTECTED} {yylval.s.str = strdup(yytext);
              return Protected;}
{PRIVATE} {yylval.s.str = strdup(yytext);
              return Private;}
{ABSTRACT} {yylval.s.str = strdup(yytext);
              return Abstract;}
{STATIC} {yylval.s.str = strdup(yytext);
              return Static;}
{SEALED} {yylval.s.str = strdup(yytext);
              return Sealed;}
{NON_SEALED} {yylval.s.str = strdup(yytext);
              return Non_sealed;}
{STRICTFP} {yylval.s.str = strdup(yytext);
              return  Strictfp;}
{IDENTIFIER} {yylval.s.str = strdup(yytext); yylval.s.var = strdup(yytext);
              return Identifier;}
<<EOF>> {yyterminate();}
. {cerr << "Illegal character " << yytext[0] << " in line " << yylineno << '\n'; return 0;}
%%

int yywrap(){
    return 1;
}