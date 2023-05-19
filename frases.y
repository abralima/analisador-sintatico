%{
/* analisador sintático para reconhecer frases em português */
#include <iostream>
using std::cout;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
%}

%token SOME ALL VALUE MIN MAX EXACTLY THAT ONLY NOT AND OR CLASS PROPERTY CARDINAL PARENTHESIS CHAVES VIRGULA

%%

sint: owl sint
	 | owl		     
	 ;

owl: CLASS opt1
	 | opt2
	 ;

opt1: definida		{ cout << "Classe Definida.\n"; }
	 | primitiva	{ cout << "Classe Primitiva.\n"; }
	 ;

opt2: enumerada		{ cout << "Classe Enumerada.\n"; }
	 | coberta		{ cout << "Classe Coberta.\n"; }
	 ;

definida: AND PARENTHESIS PROPERTY reserved opt3
	 ;

opt3: CLASS PARENTHESIS
	| CARDINAL CLASS PARENTHESIS
	| CARDINAL PARENTHESIS
	| PARENTHESIS CLASS definida PARENTHESIS PARENTHESIS
	|
	;

primitiva: PROPERTY reserved CLASS primitiva
	 | PROPERTY reserved CARDINAL CLASS primitiva
	 | PROPERTY ONLY PARENTHESIS coberta PARENTHESIS
	 | PROPERTY reserved enumerada
	 |
	 ;

enumerada: CHAVES CLASS VIRGULA enumerada CHAVES
	 | CLASS VIRGULA enumerada
	 | CLASS
	 ;

coberta: CLASS OR coberta
	 | CLASS
	 ;

reserved: SOME
	 | ALL
	 | VALUE
	 | MIN
	 | MAX
	 | EXACTLY
	 | THAT
	 | NOT
	 ;




%%

/* definido pelo analisador léxico */
extern FILE * yyin;  

int main(int argc, char ** argv)
{
	/* se foi passado um nome de arquivo */
	if (argc > 1)
	{
		FILE * file;
		file = fopen(argv[1], "r");
		if (!file)
		{
			cout << "Arquivo " << argv[1] << " não encontrado!\n";
			exit(1);
		}
		
		/* entrada ajustada para ler do arquivo */
		yyin = file;
	}

	yyparse();
}

void yyerror(const char * s)
{
	/* variáveis definidas no analisador léxico */
	extern int yylineno;    
	extern char * yytext;   

	/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
    cout << "Erro sintático: símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
}
