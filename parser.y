%{
    #include<bits/stdc++.h>
    #include <fstream>
    using namespace std;
    extern int yylex();
    int yyerror(const char*s);
    #define YYERROR_VERBOSE 1
    #define pb push_back
    extern int yylineno;
    class Entry{
        public:
            string Token;
            string Type;
            int Line;
            long int Offset;
            string Scope;
            vector<string> Params;
            Entry(){
            }
            Entry(string token, string type, int line, long int offset, string scope, vector<string> params){
                Token = token;
                Type = type;
                Line = line;
                Offset = offset;
                Scope = scope;
                Params = params;
            }
            void print_entry(){
                cout<<Token<<"    "<<Type<<"    "<<Line<<"    "<<Offset<<"    "<<Scope<<"    ";
                for(auto x:Params){
                    cout<<x<<' ';
                }
                cout<<endl;
            }
    };
    class SymbolTable{
        public:
            map<string,vector<Entry>> table;
            int level;
            SymbolTable* parent;
            SymbolTable(){
            }
            SymbolTable(SymbolTable* prev){
                if(prev){
                    parent = prev;
                    level = prev->level+1;
                }
                else{
                    parent = NULL;
                    level = 0;
                }
            }
            Entry* set(string lexeme, string token, string type, int line, long int offset, string scope, vector<string> params){
                table[lexeme].push_back(Entry(token,type,line,offset,scope,params));
                return &table[lexeme].back();
            }
            void check(Entry* e,string lexeme){
                int count = 0;
                for(int i=0;i<table[lexeme].size();i++){
                    if(e->Scope == table[lexeme][i].Scope && e->Params == table[lexeme][i].Params){
                        count++;
                }
                }
                table[lexeme] = Entry(token,type,line,offset,scope);
                    }
                table[lexeme] = Entry(token,type,line,offset,scope);
                }
                if(count > 1){
                    cerr<<"Redeclaration of "<<lexeme<<" in line "<<e->Line<<endl;
                }
            }
            vector<Entry> get(string lexeme){
                for(auto ptr=this; ptr!=NULL; ptr=ptr->parent){
                    if(ptr->table.find(lexeme)!=ptr->table.end()){
                        return ptr->table[lexeme];
                    }
                }
                cerr<<"Undeclared "<< lexeme << " on line "<<yylineno<<endl;
                return {};
            }
            void print(){
                for(auto it=table.begin();it!=table.end();it++){
                    for(auto it1:it->second){
                        cout<<it->first<<":    ";
                        it1.print_entry();
                    }
                }
            }
    };
    long int offset = 0;
    stack<SymbolTable*> tables;
    stack<long int> offsets;
    SymbolTable* head = new SymbolTable(NULL);
    vector<SymbolTable*> list_tables(1,head);
    stack<string> scopes;
    string scope = "Global";
    long long int sz;
    string tp;
    string tpp;
    vector<string> code;
    string scope1;
    bool flag = false;
    bool flagg = false;
    Entry* func = NULL;


    // 3AC Expressions
    vector<string> ac;
    int varnum=1;
    char* build_string() {
        int currnum = varnum++;
        char* str = (char*)malloc(sizeof(char) * floor(log10(currnum) + 1));
        sprintf(str, "t%d", currnum);
        return str;
    }
    void add_string(char *s1, char* s2, char *s3, string op) {
        string exp1 = s1, exp2 = s2, exp3 = s3;
        string expr = exp1 + " = " + exp2 + op + exp3 + ";";
        ac.pb(expr);
        return;
    }
%}
%union {
    int num;
    char * str;
    struct {int num; char *str; int size; char *type; char *var;} s;
}
%define parse.error verbose
%token<s> Keyword
%token<s> Open
%token<s> Opens
%token<s> Static
%token<s> finally
%token<s> Transient
%token<s> Native
%token<s> Var
%token<s> Relop
%token<s> And
%token<s> While
%token<s> Gt
%token<s> Minus
%token<s> Atr
%token<s> Module
%token<s> Volatile
%token<s> Eqnq
%token<s> If
%token<s> Protected
%token<s> Non_sealed
%token<s> Package
%token<s> Instanceof
%token<s> Long
%token<s> Void
%token<s> Arrow
%token<s> Uqm_identifier
%token<s> Case
%token<s> Lsb
%token<s> Dot
%token<s> Int
%token<s> Comma
%token<s> Return
%token<s> Do
%token<s> Qm
%token<s> Uses
%token<s> Eq
%token<s> throws
%token<s> Col
%token<s> Inc

%token<s> Lcb
%token<s> Mult
%token<s> Continue
%token<s> Bool_or
%token<s> Else
%token<s> Shifter
%token<s> Tilde
%token<s> Semicol
%token<s> Requires
%token<s> Transitive
%token<s> To
%token<s> Super
%token<s> Bbyte
%token<s> Final
%token<s> Exports
%token<s> Dec
%token<s> Mod
%token<s> With
%token<s> Bool_and
%token<s> Throw
%token<s> Default
%token<s> Lb
%token<s> Extends
%token<s> Bboolean
%token<s> Identifier
%token<s> Threed
%token<s> Div
%token<s> Rcb
%token<s> Eqq
%token<s> Interface
%token<s> New
%token<s> Break
%token<s> Record
%token<s> Lt
%token<s> Private
%token<s> Sealed
%token<s> Provides
%token<s> For
%token<s> Char
%token<s> Rsb
%token<s> Rb
%token<s> This
%token<s> Switch
%token<s> Permits
%token<s> Abstract
%token<s> Literal
%token<s> Enum
%token<s> Try
%token<s> Float
%token<s> Catch
%token<s> Synchronized
%token<s> Double
%token<s> Not
%token<s> Strictfp
%token<s> Implements
%token<s> Short
%token<s> Import
%token<s> Class
%token<s> Assert
%token<s> Or
%token<s> Plus
%token<s> Xor
%token<s> Public
%token<s> Two_col
%type<s>  Goal
%type<s>  Name
%type<s>  SimpleName
%type<s>  QualifiedName
%type<s>  ClassOrInterfaceType
%type<s>  ClassType
%type<s>  InterfaceType
%type<s>  Modifiers
%type<s>  Modifier
%type<s>  MethodHeader
%type<s>  ArrayType
%type<s>  CastExpression
%type<s>  Type
%type<s>  PrimitiveType
%type<s>  NumericType
%type<s>  IntegralType
%type<s>  FloatingPointType
%type<s>  ReferenceType
%type<s>  CompilationUnit
%type<s>  ImportDeclarations
%type<s>  TypeDeclarations
%type<s>  PackageDeclaration
%type<s>  ImportDeclaration
%type<s>  SingleStaticImportDeclaration
%type<s>  StaticImportOnDemandDeclaration
%type<s>  SingleTypeImportDeclaration
%type<s>  TypeImportOnDemandDeclaration
%type<s>  TypeDeclaration
%type<s>  ClassDeclaration
%type<s>  Superr
%type<s>  Interfaces
%type<s>  InterfaceTypeList
%type<s>  ClassBody
%type<s>  ClassBodyDeclarations
%type<s>  ClassBodyDeclaration
%type<s>  ClassMemberDeclaration
%type<s>  FieldDeclaration
%type<s>  VariableDeclarators
%type<s>  VariableDeclarator
%type<s>  VariableDeclaratorId
%type<s>  VariableInitializer
%type<s>  optForUpdate
%type<s>  MethodDeclaration
%type<s>  MethodDeclarator
%type<s>  FormalParameterList
%type<s>  FormalParameter
%type<s>  Final_
%type<s>  Throws
%type<s>  ClassTypeList
%type<s>  MethodBody
%type<s>  StaticInitializer
%type<s>  ConstructorDeclaration
%type<s>  ConstructorDeclarator
%type<s>  ConstructorBody
%type<s>  ExplicitConstructorInvocation
%type<s>  InterfaceDeclaration
%type<s>  ExtendsInterfaces
%type<s>  InterfaceBody
%type<s>  InterfaceMemberDeclarations
%type<s>  InterfaceMemberDeclaration
%type<s>  ConstantDeclaration
%type<s>  ArrayInitializer
%type<s>  VariableInitializers
%type<s>  Block
%token<s> Override
%type<s>  Dummy1
%type<s>  BlockStatements
%type<s>  BlockStatement
%type<s>  LocalVariableDeclarationStatement
%type<s>  LocalVariableDeclaration
%type<s>  Statement
%type<s>  StatementNoShortIf
%type<s>  optExpression
%type<s>  Dummy3
%type<s>  optForInit
%type<s>  StatementWithoutTrailingSubstatement
%type<s>  EmptyStatement
%type<s>  LabeledStatement
%type<s>  LabeledStatementNoShortIf
%type<s>  ExpressionStatement
%type<s>  StatementExpression
%type<s>  IfThenStatement
%type<s>  IfThenElseStatement
%type<s>  IfThenElseStatementNoShortIf
%type<s>  SwitchStatement
%type<s>  SwitchBlock
%type<s>  SwitchBlockStatementGroups
%type<s>  SwitchBlockStatementGroup
%type<s>  SwitchLabels
%type<s>  SwitchLabel
%type<s>  WhileStatement
%type<s>  WhileStatementNoShortIf
%type<s>  DoStatement
%type<s>  ForStart
%type<s>  ForStatement
%type<s>  ForStatementNoShortIf
%type<s>  ForInit
%type<s>  ForUpdate
%type<s>  StatementExpressionList
%type<s>  BreakStatement
%type<s>  ContinueStatement
%type<s>  ReturnStatement
%type<s>  ThrowStatement
%type<s>  SynchronizedStatement
%type<s>  TryStatement
%type<s>  Catches
%type<s>  CatchClause
%type<s>  Finally
%type<s>  Primary
%type<s>  PrimaryNoNewArray
%type<s>  ClassInstanceCreationExpression
%type<s>  TypeArgumentsOrDiamond
%type<s>  ArgumentList
%type<s>  ArrayCreationExpression
%type<s>  DimExprs
%type<s>  DimExpr
%type<s>  Dims
%type<s>  FieldAccess
%type<s>  MethodInvocation
%type<s>  ArrayAccess
%type<s>  PostfixExpression
%type<s>  PostIncrementExpression
%type<s>  PostDecrementExpression
%type<s>  UnaryExpression
%type<s>  PreIncrementExpression
%type<s>  PreDecrementExpression
%type<s>  UnaryExpressionNotPlusMinus
%type<s>  MultiplicativeExpression
%type<s>  AdditiveExpression
%type<s>  ShiftExpression
%type<s>  RelationalExpression
%type<s>  EqualityExpression
%type<s>  AndExpression
%type<s>  ExclusiveOrExpression
%type<s>  InclusiveOrExpression
%type<s>  ConditionalAndExpression
%type<s>  ConditionalOrExpression
%type<s>  ConditionalExpression
%type<s>  AssignmentExpression
%type<s>  Assignment
%type<s>  LeftHandSide
%type<s>  AssignmentOperator
%type<s>  Expression
%type<s>  ConstantExpression
%type<s>  TypeParameters
%type<s>  TypeParameterList
%type<s>  TypeParameter
%type<s>  TypeBound
%type<s>  AdditionalBounds
%type<s>  AdditionalBound
%type<s>  TypeArguments
%type<s>  TypeArgumentList
%type<s>  TypeArgument

%start Goal

%%
Goal:
CompilationUnit
Name:
SimpleName {($$).type = ($1).type; vector<Entry> c = head->get($1.type);} 
| QualifiedName {($$).type = ($1).type; vector<Entry> c = head->get($1.type);}
SimpleName:
Identifier {($$).type = ($1).str;}
QualifiedName:
Name Dot Identifier {($$).type = ($1).type; strcat(($$).type,($2).str); strcat(($$).type,($3).str);}
ClassOrInterfaceType:
Name {($$).type = ($1).type;}
TypeArguments: 
Lt TypeArgumentList Gt {($$).type = ($1).str; strcat(($$).type,($2).type); strcat(($$).type,($3).str); tp += ($$).type;}
TypeArgumentList: 
TypeArgument Comma TypeArgumentList {($$).type = ($1).type; strcat(($$).type,($2).str); strcat(($$).type,($3).type);}
| TypeArgument {($$).type = ($1).type;}
| TypeArgument Comma TypeArguments {($$).type = ($1).type; strcat(($$).type,($2).str); strcat(($$).type,($3).type);}
TypeArgument:
ReferenceType {($$).type = ($1).type;}
ClassType:
ClassOrInterfaceType
InterfaceType:
ClassOrInterfaceType
| ClassOrInterfaceType TypeArguments
Modifiers:
Modifier
| Atr Override
| Modifiers Modifier
Modifier:
Public | Protected | Private
| Static
| Abstract | Final | Native | Synchronized | Transient | Volatile
| Default
Dummy6:
{ tp = tpp + " " + tp;}
MethodHeader:
Modifiers TypeParameters Type Dummy6 MethodDeclarator Throws 
| Modifiers TypeParameters Type Dummy6 MethodDeclarator 
|TypeParameters Type Dummy6 MethodDeclarator Throws 
|TypeParameters Type Dummy6 MethodDeclarator
| Modifiers TypeParameters Void Dummy Dummy6 MethodDeclarator Throws 
| Modifiers TypeParameters Void Dummy Dummy6 MethodDeclarator 
|TypeParameters Void Dummy Dummy6 MethodDeclarator Throws 
|TypeParameters Void Dummy Dummy6 MethodDeclarator
|Modifiers Type MethodDeclarator Throws 
| Modifiers Type MethodDeclarator 
|Type MethodDeclarator Throws 
| Type MethodDeclarator
| Modifiers Void Dummy MethodDeclarator Throws 
| Modifiers Void Dummy MethodDeclarator 
|Void Dummy MethodDeclarator Throws 
| Void Dummy MethodDeclarator
|Modifiers TypeParameters Type Dummy6 TypeArguments MethodDeclarator Throws 
| Modifiers TypeParameters Type Dummy6 TypeArguments MethodDeclarator 
|TypeParameters Type Dummy6 TypeArguments MethodDeclarator Throws 
|TypeParameters Type Dummy6 TypeArguments MethodDeclarator
|Modifiers Type TypeArguments MethodDeclarator Throws 
| Modifiers Type TypeArguments MethodDeclarator 
|Type TypeArguments MethodDeclarator Throws 
| Type TypeArguments MethodDeclarator

Dummy:
{tp = "Void"; sz = 0;}

ArrayType:
PrimitiveType Lsb Rsb {($$).type = strdup("array("); strcat($$.type,$1.type); strcat($$.type,strdup(")"));}
| Name Lsb Rsb {($$).type = strdup("array("); strcat($$.type,$1.type); strcat($$.type,strdup(")"));}
| ArrayType Lsb Rsb {($$).type = strdup("array("); strcat($$.type,$1.type); strcat($$.type,strdup(")"));}
CastExpression:
Lb PrimitiveType Dims Rb UnaryExpression | Lb PrimitiveType Rb UnaryExpression
| Lb Expression Rb UnaryExpressionNotPlusMinus
| Lb Name Dims Rb UnaryExpressionNotPlusMinus
Type:
PrimitiveType {
    ($$).type = ($1).type;
    ($$).size = ($1).size;
    tp = ($$).type;
    sz = ($$).size;
}
| ReferenceType {
    ($$).type = ($1).type;
    tp = ($$).type;
}
PrimitiveType:
NumericType {
    ($$).type = ($1).type;
    ($$).size = ($1).size;
}
| Bboolean {
    ($$).type = (char*)"Boolean";
    ($$).size = 0;
}
NumericType:
IntegralType {
    ($$).type = ($1).type;
    ($$).size = ($1).size;
}
| FloatingPointType {
    ($$).type = ($1).type;
    ($$).size = ($1).size;
}
IntegralType:
Bbyte {
    ($$).size = 1;
    ($$).type = (char*)"byte";
}
| Short {
    ($$).size = 2;
    ($$).type = (char*)"short";
}
| Int {
    ($$).size = 4;
    ($$).type = (char*)"integer";
}
| Long {
    ($$).size = 8;
    ($$).type = (char*)"long";
}
| Char {
    ($$).size = 2;
    ($$).type = (char*)"character";
}
FloatingPointType:
Float {
    ($$).size = 4;
    ($$).type = (char*)"float";
}
| Double {
    ($$).size = 8;
    ($$).type = (char*)"double";
}
ReferenceType:
ClassOrInterfaceType {($$).type = ($1).type;}
| ArrayType {($$).type = ($1).type;}
CompilationUnit:
PackageDeclaration ImportDeclarations TypeDeclarations
| PackageDeclaration ImportDeclarations
| PackageDeclaration TypeDeclarations
| PackageDeclaration 
| ImportDeclarations TypeDeclarations
|  ImportDeclarations
| TypeDeclarations
| 
ImportDeclarations:
ImportDeclaration
| ImportDeclarations ImportDeclaration
TypeDeclarations:
TypeDeclaration
| TypeDeclarations TypeDeclaration
PackageDeclaration:
Package Name Semicol
ImportDeclaration:
SingleTypeImportDeclaration
| TypeImportOnDemandDeclaration
| SingleStaticImportDeclaration 
| StaticImportOnDemandDeclaration
SingleStaticImportDeclaration: Import Static Name Dot Identifier Semicol
StaticImportOnDemandDeclaration: Import Static Name Dot Mult Semicol
SingleTypeImportDeclaration:
Import Name Semicol
TypeImportOnDemandDeclaration:
Import Name Dot Mult Semicol
TypeDeclaration:
ClassDeclaration
| InterfaceDeclaration
| Semicol
ClassDeclaration:
Modifiers Class Identifier TypeParameters Superr Interfaces {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier TypeParameters Superr Interfaces {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier TypeParameters Superr {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier TypeParameters Superr {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier TypeParameters Interfaces {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier TypeParameters Interfaces {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier TypeParameters {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier TypeParameters {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier Superr Interfaces {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier Superr Interfaces {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier Superr {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier Superr {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier Interfaces {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier Interfaces {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Class";
} ClassBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
Superr:
Extends ClassType
Interfaces:
Implements InterfaceTypeList
InterfaceTypeList:
InterfaceType
| InterfaceTypeList Comma InterfaceType
ClassBody:
Lcb 
ClassBodyDeclarations 
Rcb
| Lcb Rcb 
ClassBodyDeclarations:
ClassBodyDeclaration
| ClassBodyDeclarations ClassBodyDeclaration
ClassBodyDeclaration:
ClassMemberDeclaration
| StaticInitializer
| ConstructorDeclaration
| Block
ClassMemberDeclaration:
FieldDeclaration
| MethodDeclaration
| ClassDeclaration
| InterfaceDeclaration 
| Semicol
FieldDeclaration:
Modifiers Type VariableDeclarators Semicol | Type VariableDeclarators Semicol
| Modifiers Type TypeArguments VariableDeclarators Semicol | Type TypeArguments VariableDeclarators Semicol

VariableDeclarators:
VariableDeclarator 
| VariableDeclarators Comma VariableDeclarator
VariableDeclarator:
VariableDeclaratorId {offset = offset + sz; head->check(head->set($1.str,"Identifier",tp,yylineno,offset,scope,{}),$1.str);}
| VariableDeclaratorId {offset = offset + sz; head->check(head->set($1.str,"Identifier",tp,yylineno,offset,scope,{}),$1.str);} Eq VariableInitializer 
VariableDeclaratorId:
Identifier {$$.str = $1.str;}
| VariableDeclaratorId Lsb Rsb {tp = "array(" + tp + ")";}
VariableInitializer:
Expression
| ArrayInitializer
MethodDeclaration:
MethodHeader MethodBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
MethodDeclarator:
Identifier Lb {
    tp = "Method," + tp;
    sz = 0;
    func = head->set($1.str,"Identifier",tp,yylineno,offset,scope,{});
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.str);
    scope += " Method";
    flag = true;
} FormalParameterList Rb {tables.top()->check(func,$1.str);}
| Identifier Lb Rb {
    tp = "Method," + tp;
    sz = 0;
    func = head->set($1.str,"Identifier",tp,yylineno,offset,scope,{});
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.str);
    scope += " Method";
    flag = true;
    tables.top()->check(func,$1.str);
}
| MethodDeclarator Lsb Rsb
FormalParameterList:
FormalParameter {if(func){func->Params.push_back(tp);}}
| FormalParameterList Comma FormalParameter {if(func){func->Params.push_back(tp);}}
FormalParameter:
Type VariableDeclaratorId {offset = offset + sz; head->check(head->set($2.str,"Identifier",tp,yylineno,offset,scope,{}),$2.str);}
| Final_ Type {tp = "Final " + tp;} VariableDeclaratorId
|Type TypeArguments VariableDeclaratorId  {offset = offset + sz; head->check(head->set($3.str,"Identifier",tp,yylineno,offset,scope,{}),$3.str);}
| Final_ Type {tp = "Final " + tp;} TypeArguments VariableDeclaratorId
Final_ : Final | Final_ Final
Throws:
throws ClassTypeList
ClassTypeList:
ClassType
| ClassTypeList Comma ClassType
MethodBody:
Block
| Semicol
StaticInitializer:
Static Block
ConstructorDeclaration:
Modifiers ConstructorDeclarator Throws ConstructorBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
} 
| ConstructorDeclarator ConstructorBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers ConstructorDeclarator ConstructorBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
} 
| ConstructorDeclarator Throws ConstructorBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
ConstructorDeclarator:
SimpleName Lb {
    tp = "Constructor"; sz = 0; 
    func = head->set($1.type,"Identifier",tp,yylineno,offset,scope,{});
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.type);
    scope += " Constructor";
} FormalParameterList Rb {tables.top()->check(func,$1.type);}
| SimpleName Lb Rb {
    tp = "Constructor";
    sz = 0;
    func = head->set($1.type,"Identifier",tp,yylineno,offset,scope,{});
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.type);
    scope += " Constructor";
    tables.top()->check(func,$1.type);
}
|TypeParameters SimpleName Lb {tp = "Constructor"; sz = 0; 
    func = head->set($2.type,"Identifier",tp,yylineno,offset,scope,{});
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.type);
    scope += " Constructor";
} FormalParameterList Rb {tables.top()->check(func,$2.type);}
| TypeParameters SimpleName Lb Rb {
    tp = "Constructor";
    sz = 0;
    func = head->set($2.type,"Identifier",tp,yylineno,offset,scope,{});
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.type);
    scope += " Constructor";
    tables.top()->check(func,$2.type);
}
ConstructorBody:
Lcb
ConstructorBody1
Rcb
| Lcb Rcb 
ConstructorBody1:
ExplicitConstructorInvocation BlockStatements 
| ExplicitConstructorInvocation 
| BlockStatements 
ExplicitConstructorInvocation:
This Lb ArgumentList Rb Semicol | This Lb Rb Semicol
| Super Lb ArgumentList Rb Semicol | Super Lb Rb Semicol
InterfaceDeclaration:
Modifiers Interface Identifier ExtendsInterfaces {
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Interface Identifier ExtendsInterfaces {
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Interface Identifier {
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Interface Identifier {
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
|Modifiers Interface Identifier TypeParameters ExtendsInterfaces {
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Interface Identifier TypeParameters ExtendsInterfaces {
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Interface Identifier TypeParameters {
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{});
    head->check(func,$3.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Interface Identifier TypeParameters {
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{});
    head->check(func,$2.str);
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
ExtendsInterfaces:
Extends InterfaceType
| ExtendsInterfaces Comma InterfaceType
InterfaceBody:
Lcb 
InterfaceMemberDeclarations 
Rcb 
| Lcb Rcb
InterfaceMemberDeclarations:
InterfaceMemberDeclaration
| InterfaceMemberDeclarations InterfaceMemberDeclaration
InterfaceMemberDeclaration:
ConstantDeclaration
| MethodDeclaration
| ClassDeclaration
| InterfaceDeclaration
| Semicol
ConstantDeclaration:
FieldDeclaration
ArrayInitializer:
Lcb VariableInitializers Comma Rcb
| Lcb VariableInitializers Rcb
| Lcb Comma Rcb
| Lcb Rcb
VariableInitializers:
VariableInitializer
| VariableInitializers Comma VariableInitializer
Block:
Lcb 
{
    if(!flag){
        tables.push(head);
        head = new SymbolTable(head); list_tables.push_back(head);
        offsets.push(offset);
        offset = 0;
        scopes.push(scope);
        scope = "Block in " + scope;
        flagg = true;
    }
    flag = false;
}
BlockStatements
{
    if(flagg){
        head = tables.top();
        tables.pop();
        offset = offsets.top();
        offsets.pop();
        scope = scopes.top();
        scopes.pop();
    }
    flagg = false;
}
Rcb
| Lcb Rcb
BlockStatements:
BlockStatement
| BlockStatements BlockStatement
BlockStatement:
LocalVariableDeclarationStatement
| Statement
LocalVariableDeclarationStatement:
LocalVariableDeclaration Semicol
LocalVariableDeclaration:
Type TypeArguments VariableDeclarators
| Type VariableDeclarators
Statement:
StatementWithoutTrailingSubstatement
| LabeledStatement
| IfThenStatement
| IfThenElseStatement
| WhileStatement
| ForStatement
StatementNoShortIf:
StatementWithoutTrailingSubstatement
| LabeledStatementNoShortIf
| IfThenElseStatementNoShortIf
| WhileStatementNoShortIf
| ForStatementNoShortIf
StatementWithoutTrailingSubstatement:
Block
| EmptyStatement
| ExpressionStatement
| SwitchStatement
| DoStatement
| BreakStatement
| ContinueStatement
| ReturnStatement
| SynchronizedStatement
| ThrowStatement
| TryStatement
EmptyStatement:
Semicol
LabeledStatement:
Identifier Col Statement
LabeledStatementNoShortIf:
Identifier Col StatementNoShortIf
ExpressionStatement:
StatementExpression Semicol
StatementExpression:
Assignment
| PreIncrementExpression
| PreDecrementExpression
| PostIncrementExpression
| PostDecrementExpression
| MethodInvocation
| ClassInstanceCreationExpression
Dummy2:
{
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "If Statement";
    flag = true;
}
Dummy4:
{
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "Else Statement";
    flag = true;
}
Dummy5:
{
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
IfThenStatement:
If Lb Dummy2 Expression Rb Statement {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
IfThenElseStatement:
If Lb Dummy2 Expression Rb StatementNoShortIf Dummy5 Else Dummy4 Statement {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
IfThenElseStatementNoShortIf:
If Lb Dummy2 Expression Rb StatementNoShortIf Dummy5 Else Dummy4 StatementNoShortIf {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
SwitchStatement:
Switch {
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "Switch Statement";
} Lb Expression Rb SwitchBlock {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
SwitchBlock:
Lcb SwitchBlockStatementGroups SwitchLabels Rcb
| Lcb SwitchBlockStatementGroups Rcb
| Lcb SwitchLabels Rcb
| Lcb Rcb
SwitchBlockStatementGroups:
SwitchBlockStatementGroup
| SwitchBlockStatementGroups SwitchBlockStatementGroup
SwitchBlockStatementGroup:
SwitchLabels BlockStatements
SwitchLabels:
SwitchLabel
| SwitchLabels SwitchLabel
SwitchLabel:
Case ConstantExpression Col
| Default Col
Dummy1:
{
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "While Loop";
    flag = true;
}
WhileStatement:
While Dummy1 Lb Expression Rb Statement {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
WhileStatementNoShortIf:
While Dummy1 Lb Expression Rb StatementNoShortIf {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
DoStatement:
Do {
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "Do While Loop";
    flag = true;
} Statement While Lb Expression Rb Semicol {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
Dummy3:
{
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "For Loop";
    flag = true;
}
ForStart:
For Lb Dummy3 optForInit Semicol optExpression Semicol optForUpdate Rb
optForInit:
ForInit
|
optExpression:
Expression
|
optForUpdate:
ForUpdate
|
ForStart1:
For Lb Dummy3 Final_ Type VariableDeclaratorId {offset = offset + sz; head->check(head->set($6.str,"Identifier",tp,yylineno,offset,scope,{}),$6.str);} Col Expression Rb
| For Lb Dummy3 Type VariableDeclaratorId {offset = offset + sz; head->check(head->set($5.str,"Identifier",tp,yylineno,offset,scope,{}),$5.str);} Col Expression Rb
ForStatement:
ForStart Statement {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| ForStart1 Statement {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
ForStatementNoShortIf:
ForStart StatementNoShortIf {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| ForStart1 StatementNoShortIf {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
ForInit:
StatementExpressionList
| LocalVariableDeclaration
ForUpdate:
StatementExpressionList
StatementExpressionList:
StatementExpression
| StatementExpressionList Comma StatementExpression
BreakStatement:
Break Identifier Semicol | Break Semicol
ContinueStatement:
Continue Identifier Semicol | Continue Semicol
ReturnStatement:
Return Expression Semicol | Return Semicol
ThrowStatement:
Throw Expression Semicol
SynchronizedStatement:
Synchronized Lb Expression Rb Block
TryStatement:
Try Block Catches
| Try Block Catches Finally | Try Block Finally
Catches:
CatchClause
| Catches CatchClause
CatchClause:
Catch {
    tp = "Catch Parameter";
    sz = 0;
    tables.push(head);
    head = new SymbolTable(head); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "Catch Clause";
    flag = true;
} Lb FormalParameter Rb Block {
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
Finally:
finally Block
Primary:
PrimaryNoNewArray
| ArrayCreationExpression
PrimaryNoNewArray:
Literal
| This
| Lb Expression Rb
| ClassInstanceCreationExpression
| FieldAccess
| MethodInvocation
| ArrayAccess
ClassInstanceCreationExpression:
New ClassType Lb ArgumentList Rb | New ClassType Lb Rb
|Primary Dot New ClassType Lb ArgumentList Rb | Primary Dot New ClassType Lb Rb
|New TypeArguments ClassType Lb ArgumentList Rb | New TypeArguments ClassType Lb Rb
|Primary Dot New TypeArguments ClassType Lb ArgumentList Rb | Primary Dot New TypeArguments ClassType Lb Rb

|Name Dot New ClassType Lb ArgumentList Rb | Name Dot New ClassType Lb Rb
|Name Dot New TypeArguments ClassType Lb ArgumentList Rb | Name Dot New TypeArguments ClassType Lb Rb


|New ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | New ClassType TypeArgumentsOrDiamond Lb Rb
|Primary Dot New ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | Primary Dot New ClassType TypeArgumentsOrDiamond Lb Rb
|New TypeArguments ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | New TypeArguments ClassType TypeArgumentsOrDiamond Lb Rb
|Primary Dot New TypeArguments ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | Primary Dot New TypeArguments ClassType TypeArgumentsOrDiamond Lb Rb

|Name Dot New ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | Name Dot New ClassType TypeArgumentsOrDiamond Lb Rb
|Name Dot New TypeArguments ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | Name Dot New TypeArguments ClassType TypeArgumentsOrDiamond Lb Rb


TypeArgumentsOrDiamond : Lt Gt | TypeArguments

ArgumentList:
Expression
| ArgumentList Comma Expression


ArrayCreationExpression:
New PrimitiveType DimExprs Dims | New PrimitiveType DimExprs
| New ClassOrInterfaceType DimExprs Dims | New ClassOrInterfaceType DimExprs
|New PrimitiveType Dims ArrayInitializer
| New ClassOrInterfaceType Dims ArrayInitializer

DimExprs:
DimExpr
| DimExprs DimExpr
DimExpr:
Lsb Expression Rsb
Dims:
Lsb Rsb
| Dims Lsb Rsb
FieldAccess:
Primary Dot Identifier
| Super Dot Identifier
MethodInvocation:
Name Lb ArgumentList Rb | Name Lb Rb
| Primary Dot TypeArguments Identifier Lb ArgumentList Rb | Primary Dot TypeArguments Identifier Lb Rb
| Super Dot TypeArguments Identifier Lb ArgumentList Rb | Super Dot TypeArguments Identifier Lb Rb
| Name Dot TypeArguments Identifier Lb ArgumentList Rb | Name Dot TypeArguments Identifier Lb Rb
| Primary Dot Identifier Lb ArgumentList Rb | Primary Dot Identifier Lb Rb
| Super Dot Identifier Lb ArgumentList Rb | Super Dot Identifier Lb Rb
ArrayAccess:
Name Lsb Expression Rsb
| PrimaryNoNewArray Lsb Expression Rsb
PostfixExpression:
Primary
| Name
| PostIncrementExpression
| PostDecrementExpression
PostIncrementExpression:
PostfixExpression Inc
PostDecrementExpression:
PostfixExpression Dec
UnaryExpression:
PreIncrementExpression
| PreDecrementExpression
| Plus UnaryExpression
| Minus UnaryExpression
| UnaryExpressionNotPlusMinus
PreIncrementExpression:
Inc UnaryExpression
PreDecrementExpression:
Dec UnaryExpression
UnaryExpressionNotPlusMinus:
PostfixExpression
| Tilde UnaryExpression
| Not UnaryExpression
| CastExpression
MultiplicativeExpression:
UnaryExpression
| MultiplicativeExpression Mult UnaryExpression { ($$).var = build_string(); add_string(($$).var, ($1).var, ($3).var, " * ");}
| MultiplicativeExpression Div UnaryExpression { ($$).var = build_string(); add_string(($$).var, ($1).var, ($3).var, " / ");}
| MultiplicativeExpression Mod UnaryExpression { ($$).var = build_string(); add_string(($$).var, ($1).var, ($3).var, " % ");}
AdditiveExpression:
MultiplicativeExpression {($$).var = strdup(($1).var);}
| AdditiveExpression Plus MultiplicativeExpression { ($$).var = build_string(); add_string(($$).var, ($1).var, ($3).var, " + ");}
| AdditiveExpression Minus MultiplicativeExpression { ($$).var = build_string(); add_string(($$).var, ($1).var, ($3).var, " - ");}
ShiftExpression:
AdditiveExpression
| ShiftExpression Shifter AdditiveExpression
RelationalExpression:
ShiftExpression
| RelationalExpression Lt ShiftExpression
| RelationalExpression Gt ShiftExpression
| RelationalExpression Relop ShiftExpression
| RelationalExpression Instanceof ReferenceType
EqualityExpression:
RelationalExpression
| EqualityExpression Eqnq RelationalExpression
AndExpression:
EqualityExpression
| AndExpression And EqualityExpression
ExclusiveOrExpression:
AndExpression
| ExclusiveOrExpression Xor AndExpression
InclusiveOrExpression:
ExclusiveOrExpression
| InclusiveOrExpression Or ExclusiveOrExpression
ConditionalAndExpression:
InclusiveOrExpression
| ConditionalAndExpression Bool_and InclusiveOrExpression
ConditionalOrExpression:
ConditionalAndExpression
| ConditionalOrExpression Bool_or ConditionalAndExpression
ConditionalExpression:
ConditionalOrExpression
| ConditionalOrExpression Qm Expression Col ConditionalExpression
AssignmentExpression:
ConditionalExpression
| Assignment
Assignment:
LeftHandSide AssignmentOperator AssignmentExpression
LeftHandSide:
Name
|FieldAccess
|ArrayAccess
AssignmentOperator:
Eqq | Eq
Expression:
AssignmentExpression
ConstantExpression:
Expression
TypeParameters: Lt TypeParameterList Gt {($$).type = ($1).str; strcat(($$).type,($2).type); strcat(($$).type,($3).str); tpp = ($$).type;}
TypeParameterList:
 TypeParameter {($$).type = ($1).type;}
 | TypeParameter Comma TypeParameterList {($$).type = ($1).type; strcat(($$).type,($2).str); strcat(($$).type,($3).type);}
 | TypeParameter Comma TypeParameters {($$).type = ($1).type; strcat(($$).type,($2).str); strcat(($$).type,($3).type);}
TypeParameter : Identifier TypeBound {($$).type = ($1).str;}
TypeBound : | Extends ClassOrInterfaceType AdditionalBounds;
AdditionalBounds: | AdditionalBounds AdditionalBound
AdditionalBound : And InterfaceType;
%%

int main() {
    yyparse();
    // for(auto x:list_tables){
    //     x->print();
    //     cout<<endl;
    // }
    for(auto s : ac) {
        cout << s << endl;
    }
    return 0;
}

int yyerror(const char *s) {
    printf("%s %d",s,yylineno);
    return 0;
}