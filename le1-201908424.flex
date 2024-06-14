/* CS 155 */
/* Completion Requirements by Gabrielle Constantino - 201908424*/

%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
int line_number = 1;
void ret_print(char *token_type);
void yyerror();
%}
Reserved             "PROCEDURE"|"VAR"|"WRITELN"|"NOT"|"IF"|"THEN"|"ELSE"|"WHILE"|"DO"|"FOR"|"TO"|"DOWNTO"|":="|"BEGIN"|"END"
Type                 "INTEGER"|"REAL"|"BOOLEAN"|"STRING"
Sign                 \+|\-
RelOp                "="|"<>"|"<"|"<="|">"|">="
AddOp                "OR"|{Sign}
MulOp                "*"|"/"|"DIV"|"MOD"|"AND"
Ident                {Letter}({Letter}|{Digit})+
Letter               [a-zA-Z]
String               \"{StringChar}{StringChar}+\"
Number               {IntNumber}|{RealNumber}
IntNumber            {DigitSeq}
DigitSeq             {Sign}?{UnsignedDigitSeq}
UnsignedDigitSeq     {Digit}{Digit}*
Digit                [0-9]
RealNumber           {DigitSeq}\.{UnsignedDigitSeq}?
StringChar           [^"]
Var                  {Ident}
%%
"\n"                 {line_number++;}
[\(\)]               {ret_print("Paren");}
{Reserved}           {ret_print("Reserved");}
";"                  {ret_print("Semicolon");}
":"                  {ret_print("Colon");}
"\""                 {ret_print("LoneQuote"); }
{Type}               {ret_print("Type");}
{Sign} 	            {ret_print("Sign"); }
{RelOp} 	            {ret_print("RelOp"); }
{AddOp} 	            {ret_print("AddOp"); }
{MulOp} 	            {ret_print("MulOp"); }
{String}             {ret_print("String");}
[\t\r\f]+	         /* whitespace */
[ ]+	               /* whitespace */
{Number}             {ret_print("Number");}
{Var} 	            {ret_print("Var"); }
{StringChar}         {ret_print("StringChar");}

%%

void ret_print(char *token_type){
   printf("L%d: \t<%s, \t\"%s\">\n", line_number, token_type, yytext);
}

void yyerror(char *message){
   printf("L%d: \tlexical error %s\n", line_number, yytext);
   exit(1);
}

int main(int argc, char *argv[]){
   yyin = fopen(argv[1], "r");
   yylex();
   fclose(yyin);
   return 0;
}
