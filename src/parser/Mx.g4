grammar Mx;
@header {package parser;}

program: (funcDef | classDef | (varDef ';'))* EOF;

classDef: Class Identifier '{' (varDef ';'| funcDef | classconstruct)* '}' ';';

classconstruct: Identifier '(' ')' block;

funcDef: returnType Identifier '(' paralist? ')' block;
paralist: type Identifier(Comma type Identifier)*;

varDef: type varDefn (Comma varDefn)*;
varDefn: Identifier(Assign expression)?;

returnType: Void | type;
type: typename ('[' ']')*;
typename : Bool | Int | String | Identifier;

block: '{' stmt* '}';

arrayConst: ( '{' (((literal Comma)* literal) | ()) '}');

literal : True | False | IntegerConst | StringConst | Null | arrayConst | formatStr;

primary
    : Identifier
    | literal
    | This
    ;
stmt
    : block #blockStmt
    | varDef ';' #vardefStmt
    | If '(' expression ')' thenStmt = stmt
        (Else elseStmt = stmt)? #ifStmt
    | While '(' expression ')' stmt #whileStmt
    | For '(' initStmt = stmt  condExpr = expression? ';' stepexpr = expression ')' stmt #forStmt
    | Return  expression? ';' #returnStmt
    | Break ';' #breakStmt
    | Continue ';' #continueStmt
    | expression ';' #exprStmt
    | ';' #emptyStmt
;

// From Conless
expression
   : New typename ('[' expression? ']') + (arrayConst?) #newArrayExpr
   | New typename ('(' ')')? #newVarExpr
   | expression '(' (expression (Comma expression)*)? ')' #callExpr
   | expression '[' expression ']' #arrayExpr
   | expression op = Member Identifier #memberExpr
   | expression op = (Increment | Decrement) #unaryExpr
   | <assoc = right> op= (Not | LogicNot | Minus | Plus) expression #unaryExpr
   | <assoc = right> op= (Increment | Decrement) expression #preSelfExpr
   | expression op = (Mul | Div | Mod) expression #binaryExpr
   | expression op = (Plus | Minus) expression #binaryExpr
   | expression op = (LeftShift | RightShift) expression #binaryExpr
   | expression op = (Greater | GreaterEqual | Less | LessEqual) expression #binaryExpr
   | expression op = (Equal | UnEqual) expression #binaryExpr
   | expression op = And expression #binaryExpr
   | expression op = Xor expression #binaryExpr
   | expression op = Or expression #binaryExpr
   | expression op = LogicAnd expression #binaryExpr
   | expression op = LogicOr expression #binaryExpr
   | <assoc = right> expression '?' expression ':' expression #conditionalExpr
   | <assoc = right> expression op=Assign expression #assignExpr
   | '(' expression ')' #parenExpr
   | primary #atomExpr
;

Void : 'void';
Bool : 'bool';
Int : 'int';
String : 'string';
New : 'new';
Class : 'class';
Null : 'null';
True : 'true';
False : 'false';
This : 'this';
If : 'if';
Else : 'else';
For : 'for';
While : 'while';
Break : 'break';
Continue : 'continue';
Return : 'return';

Plus: '+';
Minus: '-';
Mul: '*';
Div: '/';
Mod: '%';

Greater: '>';
Less: '<';
GreaterEqual: '>=';
LessEqual: '<=';
UnEqual: '!=';
Equal: '==';

LogicAnd: '&&';
LogicOr: '||';
LogicNot: '!';

RightShift: '>>';
LeftShift: '<<';
And: '&';
Or: '|';
Xor: '^';
Not: '~';

Assign: '=';

Increment: '++';
Decrement: '--';

Member: '.';

Identifier: [a-zA-Z][a-zA-Z0-9_]*;

LParen: '(';
RParen: ')';
LBracket: '[';
RBracket: ']';
LBrace: '{';
RBrace: '}';

Question: '?';
Colon: ':';
Semi : ';';
Comma : ',';

Quote: '"';
Escape: '\\\\' | '\\n' | '\\"';
IntegerConst: '0' | [1-9][0-9]*;

FstringConst: 'f'(Quote (~[$"] | '$$')*? Quote);
Fstring_l : 'f' Quote ((~[$"]|('$$'))*) '$';
Fstring_m : '$' (~[$"]|('$$'))* '$';
StringConst: (Quote (Escape | .)*? Quote);
Fstring_lst : '$' ((~[$"]|('$$'))*) Quote;
formatStr: (Fstring_l expression (Fstring_m expression )*  Fstring_lst) | FstringConst ;

WhiteSpace: [\t\r\n ]+ -> skip;
LineComment: '//' ~[\r\n]* -> skip;
ParaComment: '/*' .*? '*/' -> skip;
Non_s : ~[$] | Escape;


