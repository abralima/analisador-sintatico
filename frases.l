%{
// Reconhecedor de uma linguagem simplificada
#include <iostream>
using std::cout;
#include "frases.tab.h"
%}

%option noyywrap
delim	[ \t\n]
brancos {delim}+
letra	[A-Za-z_]
digito	[0-9]   
num	    {digito}+(\.{digito}+)?(E[+-]?{digito}+)?
comp    <|>|<>|=
chav    \{|\}
virg    \,
prts    \(|\)
pprt    has[A-Z]{letra}*|is[A-Z]{letra}*Of
card    {num}|integer\[{comp}+{num}\]
class   [A-Z]{letra}*

%%
{brancos}	; // nenhuma ação e nenhum retorno
SOME		return  SOME; 
ALL		    return ALL;
VALUE		return VALUE;
MIN		    return MIN;
MAX		    return MAX;
EXACTLY		return EXACTLY;
THAT		return THAT;
ONLY        return ONLY;
NOT		    return NOT;
AND		    return AND;
OR		    return OR;
{chav}      return CHAVES;
{virg}      return VIRGULA;
{prts}      return PARENTHESIS;
{card}      return CARDINAL;
{pprt}      return PROPERTY;
{class}     return CLASS;
.           cout << "Erro léxico: \"" << yytext << "\" não reconhecido\n"; 
%%

// nenhuma função auxiliar é necessária
