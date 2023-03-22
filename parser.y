%{
    #include<bits/stdc++.h>
    #include <fstream>
    using namespace std;
    extern int yylex();
    int yyerror(const char*s);
    #define YYERROR_VERBOSE 1
    #define pb push_back
    extern int yylineno;
    map<int,int> lev;
    vector<int> lev1;
    int l = 0, l1 = 0, l2 = 0;
    long long int sz=0;
    int f = 1;
    int f1 = 0; //for checking new
    int ln,rl = -1;
    map<string,string> conv;
    map<string,set<string>> conv1;
    int find_comma(char* s){
        int i;
        for(i=0;i<strlen(s);i++){
            if(s[i]==',')
                break;
        }
        return i;
    }
    char* widen(char* tt1,char* tt2){
        if(!strlen(tt1))
            return tt2;
        if(!strlen(tt2))
            return tt1;
        string t1(tt1),t2(tt2);
        string t11(t1),t22(t2);
        if(t1[0]>='A' && t1[0]<='Z')
            t1[0]+=32;
        if(t2[0]>='A' && t2[0]<='Z')
            t2[0]+=32;
        if(t11[0]>='A' && t11[0]<='Z')
            t11[0]+=32;
        if(t22[0]>='A' && t22[0]<='Z')
            t22[0]+=32;
        int f1=0,f2=0;
        while(t11!=""){
            if(t11 == t2){
                f1=1;
                break;
                //return tt2;
            }
            t11 = conv[t11];
        }
        while(t22!=""){
            if(t22 == t1){
                f2 = 1;
                break;
                //return tt1;
            }
            t22 = conv[t22];
        }
        if(f1 && f2){
            if(tt2 == tt1 || tt2[0]>='a' && tt2[0]<='z'){
                return tt2;
            }
            else{
                return tt1;
            }
        }
        else if(f1){
            return tt2;
        }
        else if(f2){
            return tt1;
        }
        return (char*)"";
    }
    int compare_string(char *first, char *second) {
        while (tolower(*first) == tolower(*second)) {
            if (*first == '\0' || *second == '\0')
                break;  
            first++;
            second++;
        }
        if (*first == '\0' && *second == '\0')
            return 1;
        return 0;
    }
    int compare_type(char* first, char* second){
        if(compare_string(first,second)){
            return 1;
        }
        string s1 = first, s2 = second;
        if(s1[0]>='A' && s1[0]<='Z')
            s1[0]+=32;
        if(s2[0]>='A' && s2[0]<='Z')
            s2[0]+=32;
        
        while(conv[s2]!=""){
            if(conv[s2] == s1){
                return 1;
            }
            s2 = conv[s2];
        }
        return 0;
    }
    int compare_type1(char* first, char* second){
        if(!strcmp(first,(char*)"character") || !strcmp(first,(char*)"byte") || !strcmp(first,(char*)"short")){
            if(!strcmp(second,(char*)"Character") || !strcmp(second,(char*)"Byte") || !strcmp(second,(char*)"Short") || !strcmp(second,(char*)"Integer")){
                return 1;  
            }
        }
        return 0;
    }
    int compare_type2(char* first, char* second){
        string s1(first),s2(second);
        if(conv1[s1].find(s2)==conv1[s1].end()){
            return 0;
        }
        return 1;
    }
    class Entry{
        public:
            string Token;
            string Type;
            int Line;
            long int Offset;
            string Scope;
            vector<string> Params;
            map<int,int> Dim;
            Entry(){
            }
            Entry(string token, string type, int line, long int offset, string scope, vector<string> params, map<int,int> dim){
                Token = token;
                Type = type;
                Line = line;
                Offset = offset;
                Scope = scope;
                Params = params;
                Dim = dim;
            }
            void print_entry(){
                cout<<Token<<"    ";
                for(int i=0;i<Dim.size();i++)
                    Type = "array(" + Type + ")";
                cout<<Type<<"    "<<Line<<"    "<<Offset<<"    "<<Scope<<"    ";
                for(auto x:Params){
                    cout<<x<<' ';
                }
                int term = 1;
                stack<int> s;
                for(auto x:Dim){
                    s.push(x.second/term);
                    term = x.second;
                }
                while(!s.empty()){
                    cout<<s.top()<<' ';
                    s.pop();
                }
                cout<<endl;
            }
    };
    class SymbolTable{
        public:
            map<string,vector<Entry>> table;
            int level;
            SymbolTable* parent;
            string scope_name = "Global";
            string scope_num = "";
            SymbolTable(){
            }
            SymbolTable(SymbolTable* prev, string scp, string scp_num){
                if(prev){
                    parent = prev;
                    level = prev->level+1;
                }
                else{
                    parent = NULL;
                    level = 0;
                }
                scope_name = scp + scp_num;
                scope_num = scp_num;
            }
            Entry* set(string lexeme, string token, string type, int line, long int offset, string scope, vector<string> params, map<int,int> dim){
                table[lexeme].push_back(Entry(token,type,line,offset,scope,params,dim));
                return &table[lexeme].back();
            }
            void check(Entry* e,string lexeme){
                int count = 0;
                int flag = 0;
                for(int i=0;i<table[lexeme].size();i++){
                    if(e->Scope == table[lexeme][i].Scope && e->Params == table[lexeme][i].Params){
                        count++;
                        if(table[lexeme][i].Type == "Boolean" || table[lexeme][i].Type == "string" || table[lexeme][i].Type == "Character"
                        || table[lexeme][i].Type == "Integer" || table[lexeme][i].Type == "Float" || table[lexeme][i].Type == "Null")
                            flag = 1;
                    }
                }
                if(count > 1 && flag == 0){
                    cerr<<"Redeclaration of "<<lexeme<<" in line "<<e->Line<<endl;
                }
            }
            void check1(int term){
                    lev[l] = max(lev[l],term);
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
            Entry get1(vector<Entry> c,vector<string> v){
                for(auto x:c){
                    if(x.Params.size()!=v.size())
                        continue;
                    int flag = 1;
                    for(int i=0;i<v.size();i++){
                        if(!compare_type(strdup(x.Params[i].c_str()),strdup(v[i].c_str()))){
                            flag = 0;
                            break;
                        }
                    }
                    if(flag == 1){
                        return x;
                    }
                }
                f = 0;
                ln = yylineno;
                //cerr << "Unappropriate parameters in line "<<yylineno<<endl;
                return Entry("","",-1,-1,"",{},map<int,int>());
            }
            
            void print(){
                for(auto it=table.begin();it!=table.end();it++){
                    for(auto it1:it->second){
                        if(it1.Type == "Boolean" || it1.Type == "string" || it1.Type == "Character" || it1.Type == "Integer" || it1.Type == "Float" || it1.Type == "Null")
                            continue;
                        cout<<it->first<<":    ";
                        it1.print_entry();
                    }
                }
            }
            void remove(string lexeme){
                vector<Entry> c = table[lexeme];
                for(auto it = c.begin(); it!=c.end();){
                    if(it->Params.empty()){
                        it = c.erase(it);
                    }
                    else{
                        it++;
                    }
                }
            }
    };
    long int offset = 0;
    stack<SymbolTable*> tables;
    stack<long int> offsets;
    SymbolTable* head = new SymbolTable(NULL, "Global", "");
    vector<SymbolTable*> list_tables(1,head);
    stack<string> scopes;
    string scope = "Global";
    string tp;
    string tpp;
    vector<string> code;
    string scope1;
    bool flag = false;
    bool flagg = false;
    Entry* func = NULL;
    int ind=0;
    vector<string> v;
    map<string,string> conversion;
    string ttt="";
    // 3AC Expressions
    vector<string> ac;
    map<string, int> varnum;
    void add_string(string exp1, string exp2, string exp3, string op) {
        string expr = exp1 + " = " + exp2 + " " + op + " " + exp3 + ";";
        ac.pb(expr);
        return;
    }
    char* build_string(string str, int number) {
        std::string numStr = std::to_string(number);

        std::string result = str + numStr;

        char* charArray = new char[result.length() + 1];
        strcpy(charArray, result.c_str());

        return charArray;
    }
    // void control_flow(string exp, string blockstart, string endstat) {
    //     ac.pb("if " + exp + " goto " + blockstart);
    //     ac.pb("goto " + endstat);
    //     ac.pb(blockstart + ":");
    //     return;
    // }
    // void end_control_flow(string cfstart, string nextblock) {
    //     ac.pb("goto " + cfstart);
    //     ac.pb(nextblock + ":");
    //     return;
    // }
    void add_label(string label) {
        ac.pb(label + ":");
        return;
    }
    void if_goto(string exp, string loc) {
        ac.pb("if " + exp + " goto " + loc);
        return;
    }
    void go_to(string loc) {
        ac.pb("goto " + loc);
    }
%}
%union {
    int num;
    char * str;
    struct {int num; int num1; char *str; int size; char *type; char *var; int dim1;} s;
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
%token<s> Int_Literal
%token<s> Char_Literal
%token<s> String_Literal
%token<s> Null_Literal
%token<s> Bool_Literal
%token<s> Float_Literal
%token<s> Tb
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
%type<s>  Dummy3
%type<s>  Dummy9
%type<s>  Dummy8
%type<s>  Dummy10
%type<s>  Dummy11
%type<s>  Dummy12
%type<s>  Dummy101
%type<s>  BlockStatements
%type<s>  BlockStatement
%type<s>  LocalVariableDeclarationStatement
%type<s>  LocalVariableDeclaration
%type<s>  Statement
%type<s>  StatementNoShortIf
%type<s>  optExpression
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
SimpleName {($$).type = ($1).type; vector<Entry> c = head->get($1.type);($$).str = strdup(head->get1(c,{}).Type.c_str()) ; vector<Entry> c1 = head->get($$.type); map<int,int> sz1 = head->get1(c1,{}).Dim;
    ($$).dim1 = sz1.size();} 
| QualifiedName {($$).type = ($1).type; vector<Entry> c = head->get($1.type);($$).str = strdup(head->get1(c,{}).Type.c_str()); vector<Entry> c1 = head->get($$.type); map<int,int> sz1 = head->get1(c1,{}).Dim;
    ($$).dim1 = sz1.size();}
SimpleName:
Identifier {($$).type = ($1).str;}
QualifiedName:
Name Dot Identifier {($$).type = ($3).str;}
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
Modifiers TypeParameters Type Dummy6 MethodDeclarator Throws {$$.type = $3.type;}
| Modifiers TypeParameters Type Dummy6 MethodDeclarator {$$.type = $3.type;}
|TypeParameters Type Dummy6 MethodDeclarator Throws {$$.type = $2.type;}
|TypeParameters Type Dummy6 MethodDeclarator {$$.type = $2.type;}
| Modifiers TypeParameters Void Dummy Dummy6 MethodDeclarator Throws {$$.type = (char*)"Void";}
| Modifiers TypeParameters Void Dummy Dummy6 MethodDeclarator {$$.type = (char*)"Void";}
|TypeParameters Void Dummy Dummy6 MethodDeclarator Throws {$$.type = (char*)"Void";}
|TypeParameters Void Dummy Dummy6 MethodDeclarator {$$.type = (char*)"Void";}
|Modifiers Type MethodDeclarator Throws {$$.type = $2.type;}
| Modifiers Type MethodDeclarator {$$.type = $2.type;}
|Type MethodDeclarator Throws {$$.type = $1.type;}
| Type MethodDeclarator {$$.type = $1.type;}
| Modifiers Void Dummy MethodDeclarator Throws {$$.type = (char*)"Void";}
| Modifiers Void Dummy MethodDeclarator {$$.type = (char*)"Void";}
|Void Dummy MethodDeclarator Throws {$$.type = (char*)"Void";}
| Void Dummy MethodDeclarator {$$.type = (char*)"Void";}
|Modifiers TypeParameters Type Dummy6 TypeArguments MethodDeclarator Throws {$$.type = $3.type;}
| Modifiers TypeParameters Type Dummy6 TypeArguments MethodDeclarator {$$.type = $3.type;}
|TypeParameters Type Dummy6 TypeArguments MethodDeclarator Throws {$$.type = $2.type;} 
|TypeParameters Type Dummy6 TypeArguments MethodDeclarator {$$.type = $2.type;}
|Modifiers Type TypeArguments MethodDeclarator Throws {$$.type = $2.type;}
| Modifiers Type TypeArguments MethodDeclarator {$$.type = $2.type;}
|Type TypeArguments MethodDeclarator Throws {$$.type = $1.type;}
| Type TypeArguments MethodDeclarator {$$.type = $1.type;}

Dummy:
{tp = "Void"; sz = 0;}

ArrayType:
PrimitiveType Lsb Rsb {l1++; ($$).type = ($1).type;}
| Name Lsb Rsb {l1++; ($$).type = ($1).type;}
| ArrayType Lsb Rsb {l1++;}
CastExpression:
Lb PrimitiveType Dims Rb UnaryExpression {
    if(!compare_type($2.type,$5.type) && !compare_type($5.type,$2.type)){
        cerr << "Types do not match on both the sides in line " << yylineno<<endl;
    }
    ($$).type = strdup(($2).type);
    if($5.type[0]>='A' && $5.type[0]<='Z'){
        ($$).type[0] = toupper(($$).type[0]);
    }
    if($5.dim1!=lev1.size())
        cerr << "Incompatible Type Conversion in line " << yylineno<<endl;
    ($$).dim1 = ($5).dim1; 
    ($$).str = ($5).str;
}
| Lb PrimitiveType Rb UnaryExpression {
    if(!compare_type($2.type,$4.type) && !compare_type($4.type,$2.type)){
        cerr << "Types do not match on both the sides in line " << yylineno<<endl;
    }
    ($$).type = strdup(($2).type);
    if($4.type[0]>='A' && $4.type[0]<='Z'){
        ($$).type[0] = toupper(($$).type[0]);
    }
    if($4.dim1!=lev1.size())
        cerr << "Incompatible Type Conversion in line " << yylineno<<endl;
    ($$).dim1 = ($4).dim1;
    ($$).str = ($4).str;
}
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
    ($$).size = 0;
    sz = ($$).size;
}
PrimitiveType:
NumericType {
    ($$).type = ($1).type;
    ($$).size = ($1).size;
    tp = ($$).type;
    sz = ($$).size;
}
| Bboolean {
    ($$).type = (char*)"boolean";
    ($$).size = 1;
    tp = ($$).type;
    sz = ($$).size;
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
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
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
VariableDeclaratorId {
    map<int,int> m1;
    for(int i=0;i<l1;i++){
        m1[i] = -1;
    }
    ($$).type = ($1).type;
    ($$).str = ($1).str;
    head->check(head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},m1),$1.str); if(!l1){offset = offset + sz;}; l1 = 0; lev.clear(); lev1.clear(); 
}
| VariableDeclaratorId Eq VariableInitializer {
    if(l1 != lev.size() && l1 != lev1.size()){
        if(lev.empty() && lev1.empty()){
            if(!compare_type($1.type,$3.type) || ($3).dim1 != l1){
                cerr << "Types do not match on both the sides in line " << yylineno<<endl;  
            }
            else{
                vector<Entry> c1 = head->get($3.str); map<int,int> sz1 = head->get1(c1,{}).Dim;
                head->check(head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},sz1),$1.str); lev.clear(); lev1.clear(); l1 = 0; offset = offset + sz*(sz1.size());
            }
        }
        else
            cerr << "Types do not match on both the sides in line " << yylineno<<endl;  
    }
    else if(l1 == lev.size()){
        if(strcmp($3.type,(char*)"") && !compare_type($1.type,$3.type) && !compare_type1($1.type,$3.type)){
            cerr << "Types do not match on both the sides in line " << yylineno<<endl;
        }
        if(l1!=$3.dim1+lev.size())
            cerr << "Types do not match inside the array in line " << yylineno<<endl;
        head->check(head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},lev),$1.str); int xx = 1; if(!lev.empty()) {xx =  lev.rbegin()->second;}
          offset = offset + sz*xx; lev.clear(); lev1.clear(); l1 = 0;
    }
    else{
        map<int,int> m1;
        int term = 1;
        for(int i=0;i<l1;i++){
            m1[i] = lev1[l1-1-i]*term;
            term = m1[i];
        }
        if(!compare_type($1.type,$3.type) && !compare_type1($1.type,$3.type)){
            cerr << "Types do not match on both the sides in line " << yylineno<<endl;
        }
        head->check(head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},m1),$1.str); lev.clear(); lev1.clear(); l1 = 0; offset = offset + term*sz;
    }
    ($$).type = widen(($1).type,($3).type);
    ($$).str = ($1).str;
}
VariableDeclaratorId:
Identifier {($$).str = ($1).str; ($$).type = strdup(tp.c_str());}
| VariableDeclaratorId Lsb Rsb {l1++;}
VariableInitializer:
Expression {($$).dim1 = ($1).dim1; l = 0; $$.num = 1; $$.num1 = 0; ($$).type = ($1).type; ($$).str = ($1).str;}
| ArrayInitializer {l++; $$.num = $1.num; $$.num1 = $1.num1; ($$).type = ($1).type; ($$).str = ($1).str;}
MethodDeclaration:
MethodHeader MethodBody {
    if(!compare_type($1.type,strdup(ttt.c_str())) && !compare_type1($1.type,strdup(ttt.c_str()))){
        cerr << "Return type does not match in declaration at line " << rl <<endl;
    }
    ttt = "";
    rl = -1;
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
    func = head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},lev);
    offset += sz;
    tables.push(head);
    string temp($1.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.str);
    scope += " Method";
    flag = true;
} FormalParameterList Rb {tables.top()->check(func,$1.str);}
| Identifier Lb Rb {
    tp = "Method," + tp;
    func = head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},lev);
    offset += sz;
    tables.push(head);
    string temp($1.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
Type VariableDeclaratorId {($$).str = ($2).str; head->check(head->set($2.str,"Identifier",tp,yylineno,offset,scope,{},lev),$2.str); offset = offset + sz;}
| Final_ Type VariableDeclaratorId {tp = "Final "+tp; ($$).str = ($3).str; head->check(head->set($3.str,"Identifier",tp,yylineno,offset,scope,{},lev),$3.str); offset = offset + sz;}
|Type TypeArguments VariableDeclaratorId  {($$).str = ($3).str; head->check(head->set($3.str,"Identifier",tp,yylineno,offset,scope,{},lev),$3.str); offset = offset + sz;}
| Final_ Type TypeArguments VariableDeclaratorId {tp = "Final "+tp; ($$).str = ($4).str; head->check(head->set($4.str,"Identifier",tp,yylineno,offset,scope,{},lev),$4.str); offset = offset + sz;}
Final_ : Final | Final_ Final
Throws:
throws ClassTypeList
ClassTypeList:
ClassType
| ClassTypeList Comma ClassType
MethodBody:
Block {($$).type = strdup(ttt.c_str());}
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
    func = head->set($1.type,"Identifier",tp,yylineno,offset,scope,{},lev);
    tables.push(head);
    string temp($1.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.type);
    scope += " Constructor";
} FormalParameterList Rb {tables.top()->check(func,$1.type);}
| SimpleName Lb Rb {
    tp = "Constructor";
    sz = 0;
    func = head->set($1.type,"Identifier",tp,yylineno,offset,scope,{},lev);
    tables.push(head);
    string temp($1.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.type);
    scope += " Constructor";
    tables.top()->check(func,$1.type);
}
|TypeParameters SimpleName Lb {tp = "Constructor"; sz = 0; 
    func = head->set($2.type,"Identifier",tp,yylineno,offset,scope,{},lev);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.type);
    scope += " Constructor";
} FormalParameterList Rb {tables.top()->check(func,$2.type);}
| TypeParameters SimpleName Lb Rb {
    tp = "Constructor";
    sz = 0;
    func = head->set($2.type,"Identifier",tp,yylineno,offset,scope,{},lev);
    tables.push(head);
    string temp($1.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{},lev);
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{},lev);
    head->check(func,$2.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
Lcb VariableInitializers Comma Rcb {$$.num1 = $2.num; $$.num = $2.num; head->check1($$.num1); ($$).type = ($2).type; ($$).str = ($2).str;}
| Lcb VariableInitializers Rcb {$$.num1 = $2.num; $$.num = $2.num; head->check1($$.num1); ($$).type = ($2).type; ($$).str = ($2).str;}
| Lcb Comma Rcb {$$.num1 = 0; $$.num = 0; head->check1($$.num1); ($$).type = (char*)""; ($$).str = (char*)"";}
| Lcb Rcb {$$.num1 = 0; $$.num = 0; head->check1($$.num1); ($$).type = (char*)""; ($$).str = (char*)"";}
VariableInitializers:
VariableInitializer {$$.num = $1.num; ($$).str = ($1).str;
    if(!compare_type(strdup(tp.c_str()),$1.type)){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    }
    ($$).dim1 = $1.dim1;
    ($$).type = ($1).type;
}
| VariableInitializers Comma VariableInitializer {
    $$.num = $1.num + $3.num; ($$).str = ($3).str;
    if(!compare_type(strdup(tp.c_str()),$3.type)){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    }
    ($$).dim1 = $3.dim1;
    if($1.dim1 != $$.dim1)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).type = $3.type;
}
Block:
Lcb Dummy101 BlockStatements
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
| Lcb Rcb {rl = yylineno;}

Dummy101:
{
    if(!flag){
        tables.push(head);
        head = new SymbolTable(head, scope, to_string(++varnum[scope])); list_tables.push_back(head);
        offsets.push(offset);
        offset = 0;
        scopes.push(scope);
        scope = "Block in " + scope;
        flagg = true;
    }
    flag = false;
}

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
| Final_ Type VariableDeclarators
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
Assignment {($$).type = ($1).type; ($$).str = ($1).str;}
| PreIncrementExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| PreDecrementExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| PostIncrementExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| PostDecrementExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| MethodInvocation {($$).type = ($1).type; ($$).str = ($1).str;}
| ClassInstanceCreationExpression
Dummy2:
{
    tables.push(head);
    string temp = "If";
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "If Statement";
    flag = true;
    add_label(head->scope_name);
}
Dummy4:
{
    tables.push(head);
    string temp = "Else";
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
Dummy8 Statement {
    add_label("EndIf" + head->scope_num);
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
Dummy8:
If Lb Dummy2 Expression Rb { if_goto($4.var, "IfBody" + head->scope_num); go_to("EndIf" + head->scope_num); add_label("IfBody" + head->scope_num); }
Dummy9:
Dummy8 StatementNoShortIf {add_label("EndIf" + head->scope_num);} Dummy5 Else Dummy4 {add_label(head->scope_name);}
IfThenElseStatement:
Dummy9 Statement {
    add_label("EndElse" + head->scope_num);
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
IfThenElseStatementNoShortIf:
Dummy9 StatementNoShortIf {
    add_label("EndElse" + head->scope_num);
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
Dummy13:
Switch {
    tables.push(head);
    string temp = "Switch";
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "Switch Statement";
}
SwitchStatement:
Dummy13 Lb Expression {$<s>$ = $3;} Rb SwitchBlock {
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
    string temp = "While";
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "While Loop";
    flag = true;
    add_label(head->scope_name);
}
Dummy10:
Lb Expression Rb {if_goto($2.var, "WhileBody" + head->scope_num); go_to("EndWhile" + head->scope_num); add_label("WhileBody" + head->scope_num);}
WhileStatement:
While Dummy1 Dummy10 Statement {
    go_to(head->scope_name);
    add_label("EndWhile" + head->scope_num);
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
WhileStatementNoShortIf:
While Dummy1 Dummy10 StatementNoShortIf {
    go_to(head->scope_name);
    add_label("EndWhile" + head->scope_num);
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
    string temp = "DoWhile";
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "Do While Loop";
    flag = true;
    add_label(head->scope_name);
} Statement While Lb Expression Rb Semicol {
    if_goto($4.var, head->scope_name);
    add_label("EndDoWhile" + head->scope_num);
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
    string temp = "For";
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = "For Loop";
    flag = true;
    add_label(head->scope_name);
}
Dummy11:
For Lb Dummy3 optForInit Semicol {add_label("ForExpression" + head->scope_num);}
Dummy12:
optExpression Semicol {if_goto($1.var, "ForBody" + head->scope_num); go_to("EndFor" + head->scope_num); add_label("ForUpdate" + head->scope_num);}
ForStart:
Dummy11 Dummy12 optForUpdate Rb {go_to("ForExpression" + head->scope_num); add_label("ForBody" + head->scope_num);}
optForInit:
ForInit
|
optExpression:
Expression
| {string temp = "true"; $$.var = (char *)temp.c_str();}
optForUpdate:
ForUpdate
|
ForStart1:
For Lb Dummy3 Final_ Type VariableDeclaratorId {head->check(head->set($6.str,"Identifier",tp,yylineno,offset,scope,{},lev),$6.str); offset = offset + sz;} Col Expression Rb
| For Lb Dummy3 Type VariableDeclaratorId {head->check(head->set($5.str,"Identifier",tp,yylineno,offset,scope,{},lev),$5.str); offset = offset + sz;} Col Expression Rb
ForStatement:
ForStart Statement {
    go_to("ForUpdate" + head->scope_num);
    add_label("EndFor" + head->scope_num);
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| ForStart1 Statement {
    go_to("ForUpdate" + head->scope_num);
    add_label("EndFor" + head->scope_num);
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
ForStatementNoShortIf:
ForStart StatementNoShortIf {
    go_to("ForUpdate" + head->scope_num);
    add_label("EndFor" + head->scope_num);
    head = tables.top();
    tables.pop();
    offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| ForStart1 StatementNoShortIf {
    go_to("ForUpdate" + head->scope_num);
    add_label("EndFor" + head->scope_num);
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
Return Expression Semicol {if(!ttt.length()){rl = yylineno; ttt = ($2).type;}}
 | Return Semicol {if(!ttt.length()){rl = yylineno; ttt = "Void";}}
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
    string temp = "Catch";
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
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
PrimaryNoNewArray {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1;}
| ArrayCreationExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1;}
PrimaryNoNewArray:
Bool_Literal {($$).type = (char*)"Boolean"; ($$).str = ($1).str; head->check(head->set($1.str,"Bool_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;}
| String_Literal {($$).type = (char*)"string"; ($$).str = ($1).str; head->check(head->set($1.str,"String_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;}
| Char_Literal {($$).type = (char*)"Character"; ($$).str = ($1).str; head->check(head->set($1.str,"Char_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;}
| Int_Literal {($$).type = (char*)"Integer"; ($$).str = ($1).str; head->check(head->set($1.str,"Int_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;}
| Tb {($$).type = (char*)"string"; ($$).str = ($1).str; head->check(head->set($1.str,"Tb",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;}
| Float_Literal {($$).type = (char*)"Float"; ($$).str = ($1).str; head->check(head->set($1.str,"Float_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;}
| Null_Literal {($$).type = (char*)"Null"; ($$).str = ($1).str; head->check(head->set($1.str,"Null_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;}
| This {($$).str = ($1).str;}
| Lb Expression Rb {($$).type = ($2).type; ($$).str = ($2).str;}
| ClassInstanceCreationExpression
| FieldAccess {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1;}
| MethodInvocation {($$).type = ($1).type; ($$).str = ($1).str;}
| ArrayAccess {($$).type = ($1).type; ($$).str = ($1).str;     vector<Entry> c1 = head->get($$.str); map<int,int> sz1 = head->get1(c1,{}).Dim;
    ($1).dim1 = sz1.size()-ind; ($$).dim1 = ($1).dim1; ind = 0;}
ClassInstanceCreationExpression:
New ClassType Lb ArgumentList Rb 
| New ClassType Lb Rb
|Primary Dot New ClassType Lb ArgumentList Rb 
| Primary Dot New ClassType Lb Rb
|New TypeArguments ClassType Lb ArgumentList Rb 
| New TypeArguments ClassType Lb Rb
|Primary Dot New TypeArguments ClassType Lb ArgumentList Rb 
| Primary Dot New TypeArguments ClassType Lb Rb

|Name Dot New ClassType Lb ArgumentList Rb 
| Name Dot New ClassType Lb Rb
|Name Dot New TypeArguments ClassType Lb ArgumentList Rb 
| Name Dot New TypeArguments ClassType Lb Rb


|New ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | New ClassType TypeArgumentsOrDiamond Lb Rb
|Primary Dot New ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | Primary Dot New ClassType TypeArgumentsOrDiamond Lb Rb
|New TypeArguments ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | New TypeArguments ClassType TypeArgumentsOrDiamond Lb Rb
|Primary Dot New TypeArguments ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | Primary Dot New TypeArguments ClassType TypeArgumentsOrDiamond Lb Rb

|Name Dot New ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | Name Dot New ClassType TypeArgumentsOrDiamond Lb Rb
|Name Dot New TypeArguments ClassType TypeArgumentsOrDiamond Lb ArgumentList Rb | Name Dot New TypeArguments ClassType TypeArgumentsOrDiamond Lb Rb


TypeArgumentsOrDiamond : Lt Gt | TypeArguments

ArgumentList:
Expression {v.push_back($1.type);}
| ArgumentList Comma Expression {v.push_back($3.type);}


ArrayCreationExpression:
New PrimitiveType DimExprs Dims {($$).type = ($2).type; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); strcat($$.str,$4.str); ($$).dim1 = lev1.size();}
| New PrimitiveType DimExprs {($$).type = ($2).type; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); ($$).dim1 = lev1.size();}
| New ClassOrInterfaceType DimExprs Dims {($$).type = ($2).type; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); strcat($$.str,$4.str); ($$).dim1 = lev1.size();}
| New ClassOrInterfaceType DimExprs {($$).type = ($2).type; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); ($$).dim1 = lev1.size();}
| New PrimitiveType Dims ArrayInitializer {($$).type = ($2).type; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); strcat($$.str,$4.str); ($$).dim1 = lev1.size();
    if(lev.size()!=lev1.size()){
        cerr << "Inappropriate types in line " << yylineno<<endl;  
    }

}
| New ClassOrInterfaceType Dims ArrayInitializer {($$).type = ($2).type; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); strcat($$.str,$4.str); ($$).dim1 = lev1.size();
    if(lev.size()!=lev1.size()){
        cerr << "Inappropriate types in line " << yylineno<<endl;  
    }
}

DimExprs:
DimExpr
| DimExprs DimExpr
DimExpr:
Lsb Expression Rsb {f1 = 1; lev1.push_back(stoi($2.str));
    if(!compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"integer")){
            cerr << "Array index cannot be of type " << $2.type << " in line " << yylineno<<endl;
    } 
}
Dims:
Lsb Rsb {lev1.push_back(0);}
| Dims Lsb Rsb {lev1.push_back(0);}
FieldAccess:
Primary Dot Identifier {vector<Entry> c = head->get($3.str); ($$).type = strdup(head->get1(c,{}).Type.c_str()) ; ($$).str = ($3).str; vector<Entry> c1 = head->get($$.str); map<int,int> sz1 = head->get1(c1,{}).Dim;
    ($$).dim1 = sz1.size();}
| Super Dot Identifier {($$).type = (char*)"Super"; ($$).str = ($3).str; vector<Entry> c1 = head->get($$.str); map<int,int> sz1 = head->get1(c1,{}).Dim;
    ($$).dim1 = sz1.size();}
MethodInvocation:
Name Lb ArgumentList Rb {
    vector<Entry> c = head->get($1.type);
    ($$).type = strdup(head->get1(c,v).Type.c_str());
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    if(strlen($$.type)){
        f = 1;
    }
    v.clear();
} | Name Lb Rb {
    vector<Entry> c = head->get($1.type);
    ($$).type = strdup(head->get1(c,v).Type.c_str());
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    v.clear();
}
| Primary Dot TypeArguments Identifier Lb ArgumentList Rb 
| Primary Dot TypeArguments Identifier Lb Rb
| Super Dot TypeArguments Identifier Lb ArgumentList Rb 
| Super Dot TypeArguments Identifier Lb Rb
| Name Dot TypeArguments Identifier Lb ArgumentList Rb 
| Name Dot TypeArguments Identifier Lb Rb
| Primary Dot Identifier Lb ArgumentList Rb 
| Primary Dot Identifier Lb Rb
| Super Dot Identifier Lb ArgumentList Rb 
| Super Dot Identifier Lb Rb
ArrayAccess:
Name Lsb Expression Rsb {
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++; ($$).type = ($1).str;
    ($$).str = ($1).type; 
}
| ArrayAccess Lsb Expression Rsb {
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
    ($$).str = ($1).str; 
    ($$).type = ($1).type;
}
| Bool_Literal Lsb Expression Rsb {($$).type = (char*)"Boolean"; ($$).str = ($1).str; head->check(head->set($1.str,"Bool_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| String_Literal Lsb Expression Rsb {($$).type = (char*)"string"; ($$).str = ($1).str; head->check(head->set($1.str,"String_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| Char_Literal Lsb Expression Rsb {($$).type = (char*)"Character"; ($$).str = ($1).str; head->check(head->set($1.str,"Char_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| Int_Literal Lsb Expression Rsb {($$).type = (char*)"Integer"; ($$).str = ($1).str; head->check(head->set($1.str,"Int_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| Tb Lsb Expression Rsb {($$).type = (char*)"string"; ($$).str = ($1).str; head->check(head->set($1.str,"Tb",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| Float_Literal Lsb Expression Rsb {($$).type = (char*)"Float"; ($$).str = ($1).str; head->check(head->set($1.str,"Float_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| Null_Literal Lsb Expression Rsb {($$).type = (char*)"Null"; ($$).str = ($1).str; head->check(head->set($1.str,"Null_Literal",$$.type,yylineno,offset,scope,{},{}),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| This Lsb Expression Rsb {($$).str = ($1).str;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| Lb Expression Rb Lsb Expression Rsb {($$).type = ($2).type; ($$).str = ($2).str;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| ClassInstanceCreationExpression Lsb Expression Rsb {
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| FieldAccess Lsb Expression Rsb {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}
| MethodInvocation Lsb Expression Rsb {($$).type = ($1).type; ($$).str = ($1).str;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
    } 
    ind++;
}


PostfixExpression:
Primary {($$).type = ($1).type; ($$).var = ($1).var ; ($$).str = ($1).str;}
| Name {($$).type = ($1).str; ($$).var = ($1).var ; ($$).str = ($1).type;}
| PostIncrementExpression {($$).type = ($1).str; ($$).var = ($1).var ; ($$).str = ($1).type;}
| PostDecrementExpression {($$).type = ($1).str; ($$).var = ($1).var ; ($$).str = ($1).type;}
PostIncrementExpression:
PostfixExpression Inc {add_string($1.var, $1.var, "1", "+"); $$ = $1;}
PostDecrementExpression:
PostfixExpression Dec {add_string($1.var, $1.var, "1", "-"); $$ = $1;}
UnaryExpression:
PreIncrementExpression
| PreDecrementExpression
| Plus UnaryExpression { 
    $$ = $2; ($$).var = build_string("t", ++varnum["var"]); add_string($$.var, "", $2.var, "+");
    if(!compare_string($2.type,(char*)"float") && !compare_string($2.type,(char*)"double") && !compare_string($2.type,(char*)"long") && !compare_string($2.type,(char*)"integer") && !compare_string($2.type,(char*)"short") && !compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$1.str<< "with operand of type "<< $2.type << " in line " << yylineno<<endl;
    } 
    if($2.dim1!=0)
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
}
| Minus UnaryExpression {
     $$ = $2; ($$).var = build_string("t", ++varnum["var"]); add_string($$.var, "", $2.var, "-");
     if(!compare_string($2.type,(char*)"float") && !compare_string($2.type,(char*)"double") && !compare_string($2.type,(char*)"long") && !compare_string($2.type,(char*)"integer") && !compare_string($2.type,(char*)"short") && !compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$1.str<< "with operand of type "<< $2.type << " in line " << yylineno<<endl;
    } 
    if($2.dim1!=0)
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
}
| UnaryExpressionNotPlusMinus {($$).type = ($1).type; ($$).var = ($1).var ; ($$).str = ($1).str;}
PreIncrementExpression:
Inc UnaryExpression {
    if(!compare_string($2.type,(char*)"float") && !compare_string($2.type,(char*)"double") && !compare_string($2.type,(char*)"long") && !compare_string($2.type,(char*)"integer") && !compare_string($2.type,(char*)"short") && !compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$1.str<< "with operand of type "<< $2.type << " in line " << yylineno<<endl;
    } 
    if($2.dim1!=0)
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
    add_string($2.var, $2.var, "1", "+"); $$ = $2;
}
PreDecrementExpression:
Dec UnaryExpression {
    if(!compare_string($2.type,(char*)"float") && !compare_string($2.type,(char*)"double") && !compare_string($2.type,(char*)"long") && !compare_string($2.type,(char*)"integer") && !compare_string($2.type,(char*)"short") && !compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$1.str<< "with operand of type "<< $2.type << " in line " << yylineno<<endl;
    } 
    if($2.dim1!=0)
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
    add_string($2.var, $2.var, "1", "-"); $$ = $2;
}
UnaryExpressionNotPlusMinus:
PostfixExpression {($$).type = ($1).type; ($$).var = ($1).var ; ($$).str = ($1).str;}
| Tilde UnaryExpression {
    ($$).type = ($2).type; ($$).var = ($2).var ; ($$).str = ($2).str;
    if(!compare_string($2.type,(char*)"long") && !compare_string($2.type,(char*)"integer") && !compare_string($2.type,(char*)"short") && !compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$1.str<< "with operand of type "<< $2.type << " in line " << yylineno<<endl;
    } 
    if($2.dim1!=0)
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
}
| Not UnaryExpression {
    ($$).type = ($2).type; ($$).var = ($2).var ; ($$).str = ($2).str;
    if(!compare_string($2.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$1.str<< "with operand of type "<< $2.type << " in line " << yylineno<<endl;
    } 
    if($2.dim1!=0)
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
}
| CastExpression {($$).type = ($1).type; ($$).var = ($1).var ; ($$).str = ($1).str;}
MultiplicativeExpression:
UnaryExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).var = ($1).var ;}
| MultiplicativeExpression Mult UnaryExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("t", ++varnum["var"]); add_string(($$).var, ($1).var, ($3).var, ($2).str); ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
| MultiplicativeExpression Div UnaryExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("t", ++varnum["var"]); add_string(($$).var, ($1).var, ($3).var, ($2).str); ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
| MultiplicativeExpression Mod UnaryExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("t", ++varnum["var"]); add_string(($$).var, ($1).var, ($3).var, ($2).str); ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
AdditiveExpression:
MultiplicativeExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).var = ($1).var ;}
| AdditiveExpression Plus MultiplicativeExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("t", ++varnum["var"]);
    char*s1 = (char*)"+" ;
    if(compare_string(($1).type, ($3).type)) {string t1 = ($1).type; string temp = s1; temp = temp + t1; add_string(($$).var, ($1).var, ($3).var, temp) ;}
    else {string temp = s1; temp = temp + "float"; add_string(($$).var, ($1).var, ($3).var, temp) ; ($$).type = (char*)"float";}
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
| AdditiveExpression Minus MultiplicativeExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("t", ++varnum["var"]); add_string(($$).var, ($1).var, ($3).var, ($2).str); ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
ShiftExpression:
AdditiveExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| ShiftExpression Shifter AdditiveExpression { 
    if((!compare_string($1.type,(char*)"long") && !compare_string($1.type,(char*)"integer") && !compare_string($1.type,(char*)"short") && !compare_string($1.type,(char*)"character") && !compare_string($1.type,(char*)"byte")) ||
       (!compare_string($3.type,(char*)"long") && !compare_string($3.type,(char*)"integer") && !compare_string($3.type,(char*)"short") && !compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"byte"))
    || (!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type))){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("t", ++varnum["var"]); add_string(($$).var, ($1).var, ($3).var, ($2).str); ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
RelationalExpression:
ShiftExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| RelationalExpression Lt ShiftExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("t", ++varnum["var"]); add_string(($$).var, ($1).var, ($3).var, ($2).str); ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
| RelationalExpression Gt ShiftExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("t", ++varnum["var"]); add_string(($$).var, ($1).var, ($3).var, ($2).str); ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
| RelationalExpression Relop ShiftExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("t", ++varnum["var"]); add_string(($$).var, ($1).var, ($3).var, ($2).str); ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
| RelationalExpression Instanceof ReferenceType
EqualityExpression:
RelationalExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| EqualityExpression Eqnq RelationalExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("t", ++varnum["var"]); add_string(($$).var, ($1).var, ($3).var, ($2).str); ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
AndExpression:
EqualityExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| AndExpression And EqualityExpression {
    if((!compare_string($1.type,(char*)"long") && !compare_string($1.type,(char*)"integer") && !compare_string($1.type,(char*)"short") && !compare_string($1.type,(char*)"character") && !compare_string($1.type,(char*)"byte") && !compare_string($1.type,(char*)"boolean")) ||
       (!compare_string($3.type,(char*)"long") && !compare_string($3.type,(char*)"integer") && !compare_string($3.type,(char*)"short") && !compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"byte") && !compare_string($3.type,(char*)"boolean"))
    || (!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type))){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
ExclusiveOrExpression:
AndExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| ExclusiveOrExpression Xor AndExpression {
    if((!compare_string($1.type,(char*)"long") && !compare_string($1.type,(char*)"integer") && !compare_string($1.type,(char*)"short") && !compare_string($1.type,(char*)"character") && !compare_string($1.type,(char*)"byte") && !compare_string($1.type,(char*)"boolean")) ||
       (!compare_string($3.type,(char*)"long") && !compare_string($3.type,(char*)"integer") && !compare_string($3.type,(char*)"short") && !compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"byte") && !compare_string($3.type,(char*)"boolean"))
    || (!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type))){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
InclusiveOrExpression:
ExclusiveOrExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| InclusiveOrExpression Or ExclusiveOrExpression {
    if((!compare_string($1.type,(char*)"long") && !compare_string($1.type,(char*)"integer") && !compare_string($1.type,(char*)"short") && !compare_string($1.type,(char*)"character") && !compare_string($1.type,(char*)"byte") && !compare_string($1.type,(char*)"boolean")) ||
       (!compare_string($3.type,(char*)"long") && !compare_string($3.type,(char*)"integer") && !compare_string($3.type,(char*)"short") && !compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"byte") && !compare_string($3.type,(char*)"boolean"))
    || (!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type))){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
ConditionalAndExpression:
InclusiveOrExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| ConditionalAndExpression Bool_and InclusiveOrExpression {
    if(!compare_type($1.type,(char*)"boolean") || !compare_type($3.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
ConditionalOrExpression:
ConditionalAndExpression {($$).type = ($1).type; ($$).str = ($1).str;}
| ConditionalOrExpression Bool_or ConditionalAndExpression {
    if(!compare_type($1.type,(char*)"boolean") || !compare_type($3.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< "with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
ConditionalExpression:
ConditionalOrExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1;}
| ConditionalOrExpression Qm Expression Col ConditionalExpression {
    if(!compare_type($1.type,(char*)"boolean") || (!compare_type($3.type,$5.type) && !compare_type($5.type,$3.type))){
        cerr << "Incompatible Ternary Operator with operands of types "<< $1.type << ", " << $3.type << " and "<< $5.type << " in line " << yylineno<<endl;
    }
    if($1.dim1!=0 || $3.dim1!=$5.dim1)
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    ($$).dim1 = ($3).dim1; 
    ($$).type = widen(($3).type,($5).type); ($$).str = ($3).str;
}
AssignmentExpression:
ConditionalExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1;}
| Assignment {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1;}
Assignment:
LeftHandSide AssignmentOperator AssignmentExpression {
    if(!compare_type($1.type,$3.type) && !compare_type1($1.type,$3.type)){
        cerr << "Types do not match on both the sides in line " << yylineno<<endl;
    }
    else{
            if($1.dim1 != $3.dim1)
                cerr << "Types do not match inside the array in line " << yylineno<<endl;
            else if(lev1.size()){
                head->remove($1.str);
                map<int,int> m1;
                int term = 1;
                if(lev1[0]<=0){
                    m1 = lev;
                    if(!m1.empty())
                        term = m1.rbegin()->second;
                }
                else{
                    for(int i=0;i<lev1.size();i++){
                        m1[i] = lev1[lev1.size()-1-i]*term;
                        term = m1[i];
                    }
                }
                head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},m1); offset = offset + term*sz;
            }
            ($$).type = widen(($1).type,($3).type);
            ($$).str = ($1).str;
            $$.dim1 = $1.dim1;
    }
    lev.clear(); lev1.clear(); l1 = 0;
}
LeftHandSide:
Name {($$).type = ($1).str; ($$).str = ($1).type; ($$).dim1 = ($1).dim1;}
|FieldAccess {($$).type = ($1).type; ($$).dim1 = ($1).dim1;}
|ArrayAccess {($$).type = ($1).type; vector<Entry> c1 = head->get($$.str); map<int,int> sz1 = head->get1(c1,{}).Dim;
    ($1).dim1 = sz1.size()-ind; ($$).dim1 = ($1).dim1; ind = 0;}
AssignmentOperator:
Eqq | Eq
Expression:
AssignmentExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1;}
ConstantExpression:
Expression {($$).type = ($1).type; ($$).str = ($1).str;}
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

int main(){
    conv["byte"] = "short";
    conv["short"] = "integer";
    conv["character"] = "integer";
    conv["integer"] = "long";
    conv["long"] = "float";
    conv["float"] = "double";
    conv["double"] = "";

    conv1["double"] = {"double","float","long","int","short","char","byte"};
    conv1["float"] = {"float","long","int","short","char","byte"};
    conv1["long"] = {"long","int","short","char","byte"};
    conv1["int"] = {"int","short","char","byte"};
    conv1["char"] = {"short","byte","char"};
    conv1["short"] = {"short","char","byte"};
    conv1["byte"] = {"short","char","byte"};

    yyparse();
    for(auto x:list_tables){
        x->print();
        cout<<endl;
    }
    if(f == 0){
        cerr << "Unappropriate parameters in line "<<yylineno<<endl;
    }
    for(auto s : ac) {
        cout << s << endl;
    }
    return 0;
}

int yyerror(const char *s) {
    cerr<<s<<" in line number "<<yylineno<<endl;
    return 0;
}