%{
    #include<bits/stdc++.h>
    #include <fstream>
    #include <iostream>
    #include <getopt.h>
    using namespace std;
    extern int yylex();
    int yyerror(const char*s);
    #define YYERROR_VERBOSE 1
    #define pb push_back
    #define YYDEBUG 1
    extern int yylex();
    extern FILE* yyin ;
    extern int yylineno;
    bool verbose = false;
    static struct option long_options[] = {
        {"input", required_argument, 0, 'i'},
        {"output", required_argument, 0, 'o'},
        {"help", no_argument, 0, 'h'},
        {"verbose", no_argument, 0, 'v'},
        {0, 0, 0, 0}
};
    int nearestPowerOf2(int N){
    int a = log2(N);
    return pow(2, a + 1);
}
    map<int,int> lev;
    vector<int> lev1,lev2;
    map<string, int> sp_offset ;
    string symtable = "" ;
    class SymbolTable;
    int l = 0, l1 = 0, l2 = 0;
    long long int sz=0;
    int f = 1;
    int ff=0,ff1=0;
    int inc_flag = 0 ;
    int f1 = 0; //for checking new
    int ln,rl = -1;
    int f3=1, f4=0;
    int reg_flag = 0 ;
    int func_flag = 0 ;
    int print_flag = 0 ;
    vector<int> err ;
    vector<string> v,v1;
    vector<string> func_params;
    map<string,string> conv;
    map<string,set<string>> conv1;
    int count_files = 1 ;
    int op_assoc(string op){
        if(op[0] == '+' || op[0] == '*' || op[0] == '/' || op[0] == '%') return 0 ;
        else return 1 ;
    }
    string csv_name(){
        return "symboltable" + to_string(count_files++) + ".csv" ;
    }
    int find_comma(char* s){
        int i;
        for(i=0;i<strlen(s);i++){
            if(s[i]==',')
                break;
        }
        if(i==strlen(s))
            return -1;
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
    int widen2(char* tt1,char* tt2){
        if(!strlen(tt1))
            return 0;
        if(!strlen(tt2))
            return 1;
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
            return -1 ;
        }
        else if(f1){
            return 0;
        }
        else if(f2){
            return 1;
        }
        return -1 ;
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
    vector<SymbolTable*> list_tables(1);
    class Entry{
        public:
            string Token;
            string Type;
            int Line;
            long int Offset;
            string Scope;
            vector<string> Params;
            map<int,int> Dim;
            vector<string> Mod ;
            int final_check = 0 ;
            Entry(){
            }
            Entry(string token, string type, int line, long int offset, string scope, vector<string> params, map<int,int> dim, vector<string> m){
                Token = token;
                Type = type;
                Line = line;
                Offset = offset;
                Scope = scope;
                Params = params;
                Dim = dim;
                Mod = m;
                final_check = 0 ;
            }
            stack<int> refine_dim(){
                stack<int> s;
                int term = 1;
                for(auto x:Dim){
                    s.push(x.second/term);
                    term = x.second;
                }
                return s;
            }
            void print_entry(){
                symtable = symtable + Token + ", " ;
                for(int i=0;i<Dim.size();i++)
                    Type = "array(" + Type + ")";
                int fc = find_comma(strdup(Type.c_str())) ;
                if(fc != -1) Type[fc] = '_' ;
                symtable = symtable + Type + ", " + to_string(Line) + ", " + to_string(Offset) + ", " + Scope + ", " ;                
                for(auto x:Params){
                    symtable = symtable + x + " " ;
                }
                symtable = symtable + ", " ;
                stack<int> s = refine_dim();
                while(!s.empty()){
                    symtable = symtable + to_string(s.top()) + " " ;
                    s.pop();
                }
                symtable = symtable + '\n' ;
            }
    };
    class SymbolTable{
        public:
            map<string,vector<Entry>> table;
            int level;
            SymbolTable* parent;
            string scope_name = "Global";
            string scope_num = "";
            string sn;
            int Size;
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
                    table["String"].push_back(Entry("Identifier","String",0,0,"Global",{},map<int,int>(),{}));
                    table["System"].push_back(Entry("Identifier","Class",0,0,"Global",{},map<int,int>(),{}));
                    table["out"].push_back(Entry("Identifier","Class",0,0,"Global",{},map<int,int>(),{}));
                    table["println"].push_back(Entry("Identifier","Method,Void",0,0,"Global",{},map<int,int>(),{}));
                }
                sn = scp;
                scope_name = scp + scp_num;
                scope_num = scp_num;
            }
            Entry* set(string lexeme, string token, string type, int line, long int offset, string scope, vector<string> params, map<int,int> dim, vector<string> m){
                table[lexeme].push_back(Entry(token,type,line,offset,scope,params,dim,m));
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
                if(f3 && lexeme != "out" && lexeme != "println" && lexeme != "System")
                    cerr<<"Undeclared "<< lexeme << " on line "<<yylineno<<endl;
                return {};
            }
             SymbolTable* ancestry(SymbolTable* p){
                SymbolTable* ptr = this;
                while(ptr!=NULL && ptr!=p){
                    ptr = ptr->parent;
                }
                if(ptr == p)
                    return p;
                return NULL;
            }
            SymbolTable* find_table(string s,int f){
                for(auto x:list_tables){
                    if(x->sn == s && x){
                        SymbolTable* a = this->ancestry(x->parent);
                        if(!a)
                            continue;
                        vector<Entry> c = a->table[s]; 
                        Entry c1 ;
                        if(f == 0)
                            c1 = a->get1(c,{},NULL);
                        else
                            c1 = a->get1(c,{},a);
                        if(!c1.Token.length()){
                            if(!err.empty())
                                err.pop_back();
                            continue;
                        }
                        if(c1.Type!="Class")
                            continue;
                        return x;
                    }
                }
                return NULL;
            }
            Entry get1(vector<Entry> c,vector<string> v, SymbolTable* p){
                for(auto x:c){
                    if(x.Params.size()!=v.size()){
                        if(v.empty())
                            continue;
                        else{
                            if(v[0][0]!='0'){
                                continue;
                            }
                        }
                    }
                    if((find(x.Mod.begin(),x.Mod.end(),"private")!=x.Mod.end() && !this->ancestry(p)))
                        continue;
                    if((find(x.Mod.begin(),x.Mod.end(),"static")==x.Mod.end() && !v.empty())){
                        if(v[0][0]=='0')
                            continue;
                    }
                    int flag = 1;
                    for(int i=0;i<v.size();i++){
                        if(v[0]=="0")
                            break;
                        if(!compare_type(strdup(x.Params[i].c_str()),strdup(v[i].c_str()))){
                            flag = 0;
                            break;
                        }
                    }
                    if(flag == 1){
                        return x;
                    }
                }
                ln = yylineno;
                err.push_back(yylineno);
                return Entry("","",-1,-1,"",{},map<int,int>(),{});
            }
            
            void print(){
                symtable = "Lexeme, Token, Type, Line, Offset, Scope, Prameters, Dimensions\n" ;
                for(auto it=table.begin();it!=table.end();it++){
                    for(auto it1:it->second){
                        if(it1.Type == "Boolean" || it1.Type == "string" || it1.Type == "Character" || it1.Type == "Integer" || it1.Type == "Float" || it1.Type == "Null")
                            continue;
                        symtable = symtable + it->first + ", ";
                        it1.print_entry();
                    }
                }
            }
            void remove(string lexeme){
                vector<Entry>& c = table[lexeme];
                for(auto it = c.begin(); it!=c.end();){
                    if(it->Params.empty()){
                        it = c.erase(it);
                    }
                    else{
                        it++;
                    }
                }
            }
            void counter(string s1){
                vector<Entry> *c2 ;
                for(auto ptr=this; ptr!=NULL; ptr=ptr->parent){
                    if(ptr->table.find(s1)!=ptr->table.end()){
                        c2 = &ptr->table[s1];
                        break ;
                    }
                }
                if(c2){
                    Entry* c3 ;
                    for(int j=0; j<(*c2).size(); j++){
                        if((*c2)[j].Params.size()!=0 || find((*c2)[j].Mod.begin(),(*c2)[j].Mod.end(),"private")!=(*c2)[j].Mod.end())
                            continue;
                        int final_flag = 1;
                        for(int i=0;i<v.size();i++){
                            if(!compare_type(strdup((*c2)[j].Params[i].c_str()),strdup(v[i].c_str()))){
                                final_flag = 0;
                                break;
                            }
                        }
                        if(final_flag == 1){
                            c3 = &(*c2)[j] ;
                            break ;
                        }
                    }
                    if(c3)
                        c3->final_check++ ;
                }
            }
    };
    long int offset = 0;
    stack<SymbolTable*> tables;
    stack<long int> offsets;
    SymbolTable* head = new SymbolTable(NULL, "Global", "");
    SymbolTable* head1;
    int arg_offset = 16 ;
    int func_offset = 0 ;
    map<string, string> mp_func ;
    map<string,int> mp_sz;
    stack<string> scopes;
    string scope = "Global";
    string scope_func = "Global";
    string scope_class = "Global";
    string tp;
    string tpp;
    vector<string> m;
    string scope1;
    bool flag = false;
    bool flagg = false;
    Entry* func = NULL;
    int ind=0,prod=1;
    map<string,string> conversion;
    string ttt="";
    string THIS="";


    // 3AC Expressions
    vector<string> ac;
    map<string, int> varnum;
    int offset_val = 0;
    int change_ac_val = 0;
    vector<string> static_vars;
    map<string, string> static_reg;
    vector<string> free_regs{"%r13", "%r14", "%r15"};
    bool static_case = false;
    vector<string> sta_ac;
    string op_exp(string ope){
        if(ope.size()>=3 && ope.substr(0, 3) == ">>>") {
            return "shrq";
        }
        else if(ope.size()>=2 && ope.substr(0, 2) == ">>") {
            return "sarq";
        }
        else if(ope.size()>=2 && ope.substr(0, 2) == "<<") {
            return "salq";
        }
        else if(ope[0] == '+'){
            return "addq" ;
        }
        else if(ope[0] == '-'){
            return "subq" ;
        }
        else if(ope[0] == '*'){
            return "imulq" ;
        }
        else if(ope[0] == '|'){
            return "orq" ;
        }
        else if(ope[0] == '&'){
            return "andq" ;
        }
        else if(ope[0] == '^'){
            return "xorq" ;
        }
        return "addq" ;
    }
    string bool_exp(string ope){
        if(ope.size() >= 2) {
            if(ope[0] == '=' && ope[1] == '='){
                return "e" ;
            }
            if(ope[0] == '!' && ope[1] == '='){
                return "ne" ;
            }
            if(ope[0] == '>' && ope[1] == '='){
                return "ge" ;
            }
            if(ope[0] == '<' && ope[1] == '='){
                return "le" ;
            }
        }
        if(ope[0] == '>'){
            return "g" ;
        }
        if(ope[0] == '<'){
            return "l" ;
        }
        return "e" ;
    }
    string op_unary(string ope) {
        if(ope[0] == '-') {
            return "negq";
        }
        else if(ope[0] == '~') {
            return "notq";
        }
        return "negq";
    }
    int check_reg(string st){
        if(st.size() < 2) return 0 ;
        if(st[0] == '#'  && st[1] >= '0' && st[1] <= '9') return 1 ;
        return 0 ;
    }
    int check_div(string op){
        if(op[0] == '/' || op[0] == '%') return 1 ;
        else return 0 ;
    }
    void div_op(string op, string exp1, string exp2, string exp3){
        if(op[0] == '/'){
            if(exp2[0] == '@'){
                ac.pb("movq " + mp_func[exp2] + ", %rdx") ;
                ac.pb("movq (%rdx), %rax") ;
            }
            else{
                ac.pb("movq " + mp_func[exp2] + ", %rax") ;
            }
            if(exp3[0] == '@'){
                ac.pb("movq " + mp_func[exp3] + ", %rdx") ;
                ac.pb("cltd\nidivq (%rdx)") ;
            }
            else{
                if(mp_func[exp3][0] == '$'){
                    ac.pb("movq "+mp_func[exp3]+", %rcx");
                    ac.pb("cltd\nidivq %rcx") ;
                }
                else
                    ac.pb("cltd\nidivq " + mp_func[exp3]) ;
            }
            ac.pb("movq %rax, " + mp_func[exp1]) ;
        }
        else if(op[0] == '%'){
            if(exp2[0] == '@'){
                ac.pb("movq " + mp_func[exp2] + ", %rdx") ;
                ac.pb("movq (%rdx), %rax") ;
            }
            else{
                ac.pb("movq " + mp_func[exp2] + ", %rax") ;
            }
            if(exp3[0] == '@'){
                ac.pb("movq " + mp_func[exp3] + ", %rcx") ;
                ac.pb("cltd\nidivq (%rcx)") ;
            }
            else{
                if(mp_func[exp3][0] == '$'){
                    ac.pb("movq "+mp_func[exp3]+", %rcx");
                    ac.pb("cltd\nidivq %rcx") ;
                }
                else
                    ac.pb("cltd\nidivq " + mp_func[exp3]) ;
            }
            ac.pb("movq %rdx, " + mp_func[exp1]) ;
        }
    }
    string local_offset(int l_offset){
        func_offset += l_offset ;
        string s = "-" + to_string(func_offset) + "(%rbp)" ;
        return s ;
    }
    void add_string(string exp1, string exp2, string exp3, string op) {
        if(mp_func[exp1].length()==0)
            mp_func[exp1] = local_offset(8);
        if(mp_func[exp2].length()==0)
            mp_func[exp2] = local_offset(8);
        if(mp_func[exp3].length()==0)
            mp_func[exp3] = local_offset(8);
        if(check_div(op)) div_op(op, exp1, exp2, exp3) ;
        else{
            if(exp2[0] == '@'){
                ac.pb("movq " + mp_func[exp2] + ", %rdx") ;
                ac.pb("movq (%rdx), %rax") ;
            }
            else{
                ac.pb("movq " + mp_func[exp2] + ", %rax") ;
            }
            if(exp3[0] == '@'){
                ac.pb("movq " + mp_func[exp3] + ", %rdx") ;
                ac.pb(op_exp(op) + " (%rdx), %rax") ;
            }
            else{
                ac.pb(op_exp(op) + " " + mp_func[exp3] + ", %rax") ;
            }
            ac.pb("movq %rax, " + mp_func[exp1]) ;
        }
        return;
    }
    void add_bool(string exp1, string exp2, string exp3, string op) {
        if(mp_func[exp1].length()==0)
            mp_func[exp1] = exp1;
        if(mp_func[exp2].length()==0)
            mp_func[exp2] = exp2;
        if(mp_func[exp3].length()==0)
            mp_func[exp3] = exp3;
        ac.pb("movq " + mp_func[exp2] + ", %rax");
        ac.pb("cmpq " + mp_func[exp3] + ", %rax");
        ac.pb("set" + bool_exp(op) + " %al");
        ac.pb("movzbq %al, %rax");
        ac.pb("movq %rax, " + mp_func[exp1]) ;
        return;
    }
    void add_unary(string exp1, string exp2, string op) {
        if(mp_func[exp1].length()==0)
            mp_func[exp1] = exp1;
        if(mp_func[exp2].length()==0)
            mp_func[exp2] = exp2;
        if(op != "!") { // ~ and -unary
            ac.pb("movq " + mp_func[exp2] + ", %rax");
            ac.pb(op_unary(op) + " %rax");
            ac.pb("movq %rax, " + mp_func[exp1]) ;
        }
        else {
            ac.pb("movq " + mp_func[exp2] + ", %rax");
            ac.pb("cmpq $0, %rax");
            ac.pb("sete %al");
            ac.pb("movzbq %al, %rax");
            ac.pb("movq %rax, " + mp_func[exp1]) ;
        }
        return;
    }
    void add_assignment(string exp1, string exp2,string exp3) {
        if(mp_func[exp1].length()==0)
            mp_func[exp1] = local_offset(8);
        if(mp_func[exp2].length()==0)
            mp_func[exp2] = local_offset(8);
        if(static_case) {
            sta_ac.pb("movq " + mp_func[exp2] + ", %rdx") ;
            sta_ac.pb("movq %rdx, " + mp_func[exp1]) ;
        }
        else if(ff){
            ac.pb("movq " + mp_func[exp2] + ", %rdx") ;
            if(exp2[0] == '@'){
                ac.pb("movq (%rdx), %r9") ;
                ac.pb("movq %r9, (%r8)") ;
            }
            else ac.pb("movq %rdx, (%r8)") ;
        }
        else if(ff1){
            ac.pb("movq " + mp_func[exp2] + ", %rdx") ;
            if(exp2[0] == '@'){
                ac.pb("movq (%rdx), %r9") ;
                ac.pb("movq %r9, (%r12)") ;
            }
            else ac.pb("movq %rdx, (%r12)") ;
        }
        else if(lev1.size() == 0){
            ac.pb("movq " + mp_func[exp2] + ", %rdx") ;
            ac.pb("movq %rdx, " + mp_func[exp1]) ;
        }
        ff = 0;
        ff1 = 0;
        static_case = false;
        return;
    }
    void add_address(string exp, string exp1, string exp2) {
        if(mp_func[exp2].length()==0)
            mp_func[exp2] = exp2;
        if(mp_func[exp1].length()==0)
            mp_func[exp1] = exp1;
        ac.pb("movq " + mp_func[exp1] + ", %rbx") ;
        ac.pb("addq $" + exp2 + ", %rbx") ;
        return;
    }
    void add_address1(string exp1, string exp2, int prod, string index) {
        if(mp_func[exp2].length()==0)
            mp_func[exp2] = exp2;
        if(mp_func[exp1].length()==0)
            mp_func[exp1] = exp1;
        ac.pb("movq " + mp_func[exp2] + ", %rbx");
        ac.pb("imulq $" + to_string(prod*8) + ", %rbx");
        ac.pb("addq %rbx, %rcx");
        return;
    }
    void add_param(string exp) {
        ac.pb("pushq " + mp_func[exp]);
        print_flag++ ;
        return;
    }
    void call_func(string exp, string func_name) {
        ac.pb("call " + func_name);
        return;
    }
    bool check_qualified_name_method(string exp) {
        return (exp.size() >= 2 && exp[0]=='#' && exp[1] >= '0' && exp[1] <= '9');
    }
    void change_ac(string exp) {
        string temp = ac[change_ac_val];
        temp = temp.substr(0, temp.size()-11) + exp + " //Offset";
        ac[change_ac_val] = temp;
        offset_val = 0;
        return;

    }
    int get_offset(string t){
        return 8 ;
        if(t == "integer" || t == "Integer" || t == "float" || t == "Float") return 4 ;
        else if(t == "Double" || t == "double" || t == "Long" || t == "long") return 8 ;
        else if(t == "character" || t == "Character" || t == "short" || t == "Short") return 2 ;
        else if(t == "Boolean" || t == "boolean" || t == "Byte" || t == "byte") return 1 ;
        return 8 ;
    }
    void alloc_mem(string exp) {
        int x = get_offset(tp);
        if(lev1.size()){
            for(auto i:lev1)
                x *= i;
        }
        else{
            if(THIS == tp){
                x = offsets.top();
            }
            else{
                x += mp_sz[tp];
            }
        }
        ac.pb("movl $" + to_string(x) + ", %edi") ;
        ac.pb("call malloc@PLT");
        ac.pb("movq %rax, " + mp_func[exp]) ;
        return;
    }
    char* build_string(string str, int number) {
        std::string numStr = std::to_string(number);

        std::string result = str + numStr;

        char* charArray = new char[result.length() + 1];
        strcpy(charArray, result.c_str());
        mp_func[result] = local_offset(8) ;
        return charArray;
    }
    void add_label(string label) {
        ac.pb(label + ":");
        return;
    }
    void if_goto(string exp, string loc) {
        ac.pb("cmpq $0, " + mp_func[exp]);
        ac.pb("jne " + loc) ;
        return;
    }
    void go_to(string loc) {
        ac.pb("jmp " + loc);
    }
    void callee(){
        ac.pb("pushq %rbp\nmovq %rsp, %rbp*") ;
        arg_offset = 16 ;
        func_offset = 0 ;
        reg_flag = 0 ;
        mp_func.clear() ;
        for(auto it : static_reg) {
            mp_func[it.first] = it.second;
        }
    }
    void param_offset(string s1, int p_offset){
        string s = to_string(arg_offset) + "(%rbp)" ;
        ac.pb("movq " + s + ", %rdx") ;
        s = local_offset(8) ;
        mp_func[s1] = s ; 
        ac.pb("movq %rdx, " + s) ;
        //ac.pb(s1 + " = +" + to_string(arg_offset) + "(%rbp)") ;
        arg_offset += 8 ;
    }
    int check_literal(string s){
        if(s == "Boolean" || s == "string" || s == "Character" || s == "Integer" || s == "Float" || s == "Null")
            return 0 ;
        return 1 ;
    }
    int check_obj(string s){
        if(s == "integer" || s == "character" || s == "boolean" || s == "float" || s == "double" || s == "short" 
        || s == "byte" || s == "long") return 0 ;
        return 1 ;
    }
    string findscope(bool brkorcont) {
        string sc = scope;
        stack<string> temp1;
        bool found = false;
        while(!scopes.empty()) {
            if( (sc.size()>=3 && sc.substr(0, 3)=="For") || (sc.size()>=5 && sc.substr(0, 5)=="While") || (brkorcont && sc.size()>=6 && sc.substr(0, 6)=="Switch") || (sc.size()>=7 && sc.substr(0, 7)=="DoWhile") ) {
                found = true;
                break;
            }
            sc = scopes.top();
            temp1.push(sc);
            scopes.pop();
        }
        while(!temp1.empty()) {
            scopes.push(temp1.top());
            temp1.pop();
        }
        if(!found) {
            cerr << (brkorcont? "Break":"Continue") << " declared outside any loop or switch case statement" << endl;
        }
        return sc;
    }
    string findloccont(string sc) {
        string final_loc = "End";
        if(sc.size()>=3 && sc.substr(0, 3)=="For") {
            final_loc = "ForUpdate" + sc.substr(3, sc.size()-3);
        }
        else if(sc.size()>=5 && sc.substr(0, 5)=="While") {
            final_loc = sc;
        }
        else if(sc.size()>=7 && sc.substr(0, 7)=="DoWhile") {
            final_loc = "DoWhileExpression" + sc.substr(7, sc.size()-7);
        }
        return final_loc;
    }
    bool check_print(string exp1) {
        if(exp1 == "System" || exp1 == "System.out")
            return true;
        return false;
    }
    char *make_print_string(string exp) {
        string result="println";
        if(exp=="System")
            result = "System.out";
        char* charArray = new char[result.length() + 1];
        strcpy(charArray, result.c_str());
        return charArray;
    }
    string Type_cast(string t, char*var){
        string s = var ;
        if(mp_func[s].length()==0)
            mp_func[s] = s;
        return "cast_to_" + t + "(" + mp_func[s] + ")" ;
    }
%}
%union {
    int num;
    char * str;
    struct {int num; int num1; char *str; int size; char *type; char *var; int dim1; char *cl; int ar; char* var1;} s;
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
%type<s>  New1
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
%type<s>  Dummy14
%type<s>  Dummy15
%type<s>  Dummy16
%type<s>  Dummy17
%type<s>  Dummy18
%type<s>  Dummy19
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
SimpleName {($$).type = ($1).type;  $$.var = $1.var; vector<Entry> c = head->get($1.type); Entry c1 = head->get1(c,{},head); ($$).str = strdup(c1.Type.c_str()) ; map<int,int> sz1 = c1.Dim;
    ($$).dim1 = sz1.size(); ($$).cl = ($$).str;
    string s1 = c1.Scope;
    int len = s1.length();
    if(!c1.Mod.empty() && find(c1.Mod.begin(),c1.Mod.end(),"static") != c1.Mod.end()) {
        $$.var = $1.var;
    }
    else if(c1.Type.substr(0, 6) == "Method"){}
    else if(len-5>=0 && s1[len-5]=='C' && s1[len-4]=='l' && s1[len-3]=='a' && s1[len-2]=='s' && s1[len-1]=='s'){
        ac.pb("movq "+mp_func["this"]+", %rbx");
        ac.pb("addq $"+to_string(c1.Offset)+", %rbx");
        ($$).var = build_string("@", ++varnum["arr"]);
        string st = ($$).var ;
        ac.pb("movq %rbx, " + mp_func[st]) ;
        ($$).type = ($$).var;
        ($$).ar = 100;
    }
    $$.var1 = build_string("#", ++varnum["var"]) ;
} 
| QualifiedName {($$).type = ($1).type;  $$.var = $1.var; ($$).str = ($1).str; ($$).dim1 = $1.dim1; ($$).ar = $1.ar; ($$).var1 = ($1).var1;}
SimpleName:
Identifier {($$).type = ($1).str; $$.var = $1.var; }
QualifiedName:
Name Dot Identifier { f4 = 1; ($$).type = ($3).str;
string comp1($3.str), comp2($1.type);
if(comp1=="out" || comp1=="println"){

}
else{
    if(THIS == $1.cl){ head1 = head->find_table($1.cl,1);} else {head1 = head->find_table($1.cl,0);}
    string ss = "Reference Type";
    string st = "Class";
    if(!head1){
    if(st == $1.cl && THIS == $1.type || $1.cl == ss){
        head1 = head->find_table($1.type,1);
    }
    else if(st == $1.cl){
        head1 = head->find_table($1.type,0);
    }
    }
    Entry c1;
    vector<Entry> c = head1->get($3.str); 
    if(head1){if(THIS == $1.cl){c1 = head1->get1(c,{},head1);} else if($1.cl== st && THIS == $1.type || $1.cl == ss){vector<string> v1 = {"0"}; c1 = head1->get1(c,v1,head1);} else if($1.cl == st){vector<string> v1 = {"0"}; c1 = head1->get1(c,v1,NULL);} else{c1 = head1->get1(c,{},NULL);} ($$).str = strdup(c1.Type.c_str()) ;
        if(check_print($1.var)) {$$.var = make_print_string($1.var);}
        else {
            if(c1.Offset==-1) {
                // offset_val = -1;
                change_ac_val = ac.size();
                $$.var = $3.var;
                $$.var1 = $1.var;
                //ac.pb("pushq " + mp_func[$1.var]) ;
            }
            else{
                if(!c1.Mod.empty() && find(c1.Mod.begin(),c1.Mod.end(),"static") != c1.Mod.end()) {
                    $$.var = $3.var;
                    $$.ar = 101;
                }
                else {
                    add_address("", $1.var, to_string(c1.Offset));
                    ($$).dim1 = c1.Dim.size();
                    $$.ar = 100;
                }
            }
        }
        }
    else {
                cerr<<"Class mentioned in line " << yylineno << " not found"<<endl;
                YYABORT;
        }
}
}
ClassOrInterfaceType:
Name {($$).str = ($1).type; ($$).type = ($1).str; tp = ($$).str; $$.var = $1.var;}
TypeArguments: 
Lt TypeArgumentList Gt {($$).type = ($1).str; strcat(($$).type,($2).type); strcat(($$).type,($3).str); tp += ($$).type;}
TypeArgumentList: 
TypeArgument Comma TypeArgumentList {($$).type = ($1).type; strcat(($$).type,($2).str); strcat(($$).type,($3).type);}
| TypeArgument {($$).type = ($1).type;}
| TypeArgument Comma TypeArguments {($$).type = ($1).type; strcat(($$).type,($2).str); strcat(($$).type,($3).type);}
TypeArgument:
ReferenceType {($$).type = ($1).type;}
ClassType:
ClassOrInterfaceType {$$.str = $1.str; $$.type = $1.type;}
InterfaceType:
ClassOrInterfaceType
| ClassOrInterfaceType TypeArguments
Modifiers:
Modifier {m.push_back($1.str);}
| Atr Override
| Modifiers Modifier {m.push_back($2.str);}
Modifier:
Public {$$.str = $1.str;}
| Protected 
| Private {$$.str = $1.str;}
| Static {$$.str = $1.str;}
| Abstract 
| Final {$$.str = $1.str;}
| Native 
| Synchronized 
| Transient 
| Volatile
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
| Name Lsb Rsb {l1++; ($$).type = ($1).str;}
| ArrayType Lsb Rsb {l1++;}
CastExpression:
Lb PrimitiveType Dims Rb UnaryExpression {
    if(!compare_type($2.type,$5.type) && !compare_type($5.type,$2.type)){
        cerr << "Types do not match on both the sides in line " << yylineno<<endl;
        YYABORT;
    }
    else{
        ($$).type = strdup(($2).type);
        if($5.type[0]>='A' && $5.type[0]<='Z'){
            ($$).type[0] = toupper(($$).type[0]);
        }
        if($5.dim1!=lev1.size()){
            cerr << "Incompatible Type Conversion in line " << yylineno<<endl;
            YYABORT;
        }
        else{
            ($$).dim1 = ($5).dim1; 
            ($$).str = ($5).str;
        }
    }
}
| Lb PrimitiveType Rb UnaryExpression {
    if(!compare_type($2.type,$4.type) && !compare_type($4.type,$2.type)){
        cerr << "Types do not match on both the sides in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).type = strdup(($2).type);
    if($4.type[0]>='A' && $4.type[0]<='Z'){
        ($$).type[0] = toupper(($$).type[0]);
    }
    if($4.dim1!=lev1.size()){
        cerr << "Incompatible Type Conversion in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($4).dim1;
    ($$).str = ($4).str;
    string s1 = Type_cast(($2).type, ($4).var) ;
    $$.var = build_string("#", ++varnum["var"]) ;
    add_assignment($$.var,s1,$4.str) ;
}
| Lb Expression Rb UnaryExpressionNotPlusMinus {
    if(!compare_type($2.type,$4.type) && !compare_type($4.type,$2.type)){
        cerr << "Types do not match on both the sides in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).type = strdup(($2).type);
    if($4.type[0]>='A' && $4.type[0]<='Z'){
        ($$).type[0] = toupper(($$).type[0]);
    }
    if($4.dim1!=lev1.size()){
        cerr << "Incompatible Type Conversion in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($4).dim1;
    ($$).str = ($4).str;
    string s1 = Type_cast(($2).type, ($4).var) ;
    $$.var = build_string("#", ++varnum["var"]) ;
    add_assignment($$.var,s1,$4.str) ;
}
| Lb Name Dims Rb UnaryExpressionNotPlusMinus {
    if(!compare_type($2.type,$5.type) && !compare_type($5.type,$2.type)){
        cerr << "Types do not match on both the sides in line " << yylineno<<endl;
        YYABORT;
    }
    else{
        ($$).type = strdup(($2).type);
        if($5.type[0]>='A' && $5.type[0]<='Z'){
            ($$).type[0] = toupper(($$).type[0]);
        }
        if($5.dim1!=lev1.size()){
            cerr << "Incompatible Type Conversion in line " << yylineno<<endl;
            YYABORT;
        }
        else{
            ($$).dim1 = ($5).dim1; 
            ($$).str = ($5).str;
        }
    }
}
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
    ($$).size = 8;
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
    ($$).size = 8;
    ($$).type = (char*)"short";
}
| Int {
    ($$).size = 8;
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
| Var {
    ($$).size = 4;
    ($$).type = (char*)"var";
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
ClassOrInterfaceType {($$).type = ($1).str;}
| ArrayType {($$).type = ($1).type;}
CompilationUnit:
PackageDeclaration ImportDeclarations TypeDeclarations
| PackageDeclaration ImportDeclarations
| PackageDeclaration TypeDeclarations
| PackageDeclaration 
| ImportDeclarations TypeDeclarations
|  ImportDeclarations
| TypeDeclarations
| {}
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
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($3.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$3.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier TypeParameters Superr Interfaces {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($2.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$2.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier TypeParameters Superr {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($3.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$3.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier TypeParameters Superr {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($2.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$2.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier TypeParameters Interfaces {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($3.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$3.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier TypeParameters Interfaces {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($2.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$2.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier TypeParameters {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($3.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$3.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier TypeParameters {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($2.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$2.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier Superr Interfaces {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($3.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$3.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier Superr Interfaces {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($2.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$2.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier Superr {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($3.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$3.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier Superr {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($2.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$2.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier Interfaces {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($3.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$3.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier Interfaces {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($2.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$2.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Class Identifier {
    func = head->set($3.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($3.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$3.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Class Identifier {
    func = head->set($2.str,"Identifier","Class",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    head->set($2.str,"Identifier","Reference Type",yylineno,offset,scope,{},lev,m);
    THIS = head->sn;
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope_class = scope;
    scope += " Class";
} ClassBody {
    head = tables.top();
    THIS = head->sn;
    tables.pop();
    head->Size = offset; mp_sz[$2.str] = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
Superr:
Extends ClassType {$$.str = $2.str;}
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
Modifiers Type VariableDeclarators Semicol {m.clear();} | Type VariableDeclarators Semicol {m.clear();}
| Modifiers Type TypeArguments VariableDeclarators Semicol {m.clear();} | Type TypeArguments VariableDeclarators Semicol {m.clear();}

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
    if(find(m.begin(), m.end(), "static")!=m.end()) {
        static_reg[$1.var] = free_regs[static_vars.size()%3];
        static_vars.pb($1.var);
        mp_func[$1.var] = static_reg[$1.var];
    }
    head->check(head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},m1,m),$1.str); if(!l1){offset = offset + sz;}; l1 = 0; lev.clear(); lev1.clear(); 
}
| VariableDeclaratorId Eq VariableInitializer {
    if(l1 != lev.size() && l1 != lev1.size()){
        if(lev.empty() && lev1.empty()){
            if(!compare_type($1.type,$3.type) || ($3).dim1 != l1){
                cerr << "Types do not match on both the sides in line " << yylineno<<endl;  
                YYABORT;  
            }
            else{
                vector<Entry> c1 = head->get($3.str); map<int,int> sz1 = head->get1(c1,{},head).Dim;
                if(find(m.begin(), m.end(), "static")!=m.end()) {
                    static_reg[$1.var] = free_regs[static_vars.size()%3];
                    static_vars.pb($1.var);
                    mp_func[$1.var] = static_reg[$1.var];
                    static_case = true;
                }
                head->check(head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},sz1,m),$1.str); lev.clear(); l1 = 0; offset = offset + sz*(sz1.size());
                head->counter($1.str);
            }
        }
        else{
            cerr << "Types do not match on both the sides in line " << yylineno<<endl;  
            YYABORT;  
        }
    }
    else if(l1 == lev.size()){
        if(strcmp($3.type,(char*)"") && !compare_type($1.type,$3.type) && !compare_type1($1.type,$3.type)){
            cerr << "Types do not match on both the sides in line " << yylineno<<endl;
            YYABORT;
            
        }
        if(l1!=$3.dim1+lev.size()){
            cerr << "Types do not match inside the array in line " << yylineno<<endl;
            YYABORT;
            
        }
        if(find(m.begin(), m.end(), "static")!=m.end()) {
            static_reg[$1.var] = free_regs[static_vars.size()%3];
            static_vars.pb($1.var);
            mp_func[$1.var] = static_reg[$1.var];
            static_case = true;
        }
        head->check(head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},lev,m),$1.str); int xx = 1; if(!lev.empty()) {xx =  lev.rbegin()->second;}
        head->counter($1.str);
        offset = offset + sz*xx; lev.clear(); l1 = 0;
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
            YYABORT;
        }
        if(find(m.begin(), m.end(), "static")!=m.end()) {
            static_reg[$1.str] = free_regs[static_vars.size()%3];
            static_vars.pb($1.str);
            mp_func[$1.var] = static_reg[$1.str];
            static_case = true;
        }
        head->check(head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},m1,m),$1.str); lev.clear(); l1 = 0; offset = offset + term*sz;
        head->counter($1.str);
    }
    int check_type = widen2(($1).type,($3).type);
    if(check_type != -1){
        string s1 ;
        if(check_literal($3.type)){s1 = Type_cast($1.type, strdup(mp_func[$3.var].c_str()));}
        else{s1 = Type_cast($1.type, $3.var);}
        string s2 = build_string("#", ++varnum["var"]) ;
        add_assignment(s2, s1,$1.str);
        if(mp_func[$1.var].length() == 0){
            mp_func[$1.var] = local_offset(get_offset($1.type)) ;
            add_assignment($1.var, s2,$1.str) ;
        }
        else add_assignment($1.var, s2,$1.str) ;
    }
    else{
        string sarr = $3.var ;
        if(mp_func[$1.var].length() == 0){
            if(sarr[0] == '@') {mp_func[$1.var] = "-" + to_string(func_offset) + "(%rbp)" ;}
            else{
                mp_func[$1.var] = local_offset(get_offset($1.type)) ;
                add_assignment($1.var, $3.var,$1.str) ;
            }
        }
        else{
            if(sarr[0] == '@') mp_func[$1.var] = "-" + to_string(func_offset) + "(%rbp)" ;
            else{
                add_assignment($1.var, $3.var,$1.str) ;
            }
        }
    }
    lev1.clear();
    ($$).type = widen(($1).type,($3).type);
    ($$).str = ($1).str;
    static_case = false;
}
VariableDeclaratorId:
Identifier {($$).str = ($1).str; ($$).type = strdup(tp.c_str()); if(check_obj(tp) && !mp_func[$1.str].length()){mp_func[$1.str] = $1.str ;}}
| VariableDeclaratorId Lsb Rsb {l1++;}
VariableInitializer:
Expression {($$).dim1 = ($1).dim1; l = 0; $$.num = 1; $$.num1 = 0; ($$).type = ($1).type; ($$).str = ($1).str;}
| ArrayInitializer {l++; $$.num = $1.num; $$.num1 = $1.num1; ($$).type = ($1).type; ($$).str = ($1).str;}
MethodDeclaration:
MethodHeader MethodBody {
    if(!compare_type($1.type,strdup(ttt.c_str())) && !compare_type1($1.type,strdup(ttt.c_str())) && !(ttt.length() == 0 && $1.type==(char*)"Void")){
        cerr << "Return type does not match in declaration at line " << rl <<endl;
        YYABORT;
    }
    ttt = "";
    rl = -1;
    sp_offset[head->scope_name] = func_offset ;
    string st = head->scope_name ;
    add_label("Return" + scope_func);
    if(st == "main") ac.pb("movq $0, %rax") ;
    ac.pb("leave\nret");
    ac.pb("");
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
MethodDeclarator:
Identifier Lb {
    tp = "Method," + tp;
    func = head->set($1.str,"Identifier",tp,yylineno,-1,scope,{},lev,m);
    m.clear();
    tables.push(head);
    string temp($1.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.str);
    scope_func = scope;
    scope += " Method";
    flag = true;
    ac.pb("");
    add_label(head->scope_name);
    callee() ;
    
} FormalParameterList Rb {tables.top()->check(func,$1.str); param_offset("this", 8) ;}
| Identifier Lb Rb {
    tp = "Method," + tp;
    func = head->set($1.str,"Identifier",tp,yylineno,-1,scope,{},lev,m);
    m.clear();
    tables.push(head);
    string temp($1.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.str);
    scope_func = scope;
    scope += " Method";
    flag = true;
    tables.top()->check(func,$1.str);
    ac.pb("");
    add_label(head->scope_name);
    callee() ;
    param_offset("this", 8) ;
}
| MethodDeclarator Lsb Rsb
FormalParameterList:
FormalParameter { string tp1 = tp; for(int i=0;i<l1;i++) tp1 = "array("+tp1+")";
    if(func){func->Params.push_back(tp1);} param_offset($1.var, get_offset(tp)) ;
 lev.clear(); l1 = 0; lev1.clear();}
| FormalParameterList Comma FormalParameter { string tp1 = tp; for(int i=0;i<l1;i++) tp1 = "array("+tp1+")";
    if(func){func->Params.push_back(tp1);} param_offset($3.var, get_offset(tp)) ;
 lev.clear(); l1 = 0; lev1.clear();}
FormalParameter:
Type VariableDeclaratorId {
    map<int,int> m1;
    for(int i=0;i<l1;i++){
        m1[i] = -1;
    }
    ($$).str = ($2).str; ($$).var = ($2).var; head->check(head->set($2.str,"Identifier",tp,yylineno,offset,scope,{},m1,m),$2.str); m.clear(); offset = offset + sz;
}
| Final_ Type VariableDeclaratorId {
    map<int,int> m1;
    for(int i=0;i<l1;i++){
        m1[i] = -1;
    }
    ($$).str = ($3).str; ($$).var = ($3).var; head->check(head->set($3.str,"Identifier",tp,yylineno,offset,scope,{},m1,m),$3.str); m.clear(); offset = offset + sz;
}
|Type TypeArguments VariableDeclaratorId  {
    map<int,int> m1;
    for(int i=0;i<l1;i++){
        m1[i] = -1;
    }
    ($$).str = ($3).str; ($$).var = ($3).var; head->check(head->set($3.str,"Identifier",tp,yylineno,offset,scope,{},m1,m),$3.str); m.clear(); offset = offset + sz;
}
| Final_ Type TypeArguments VariableDeclaratorId {
    map<int,int> m1;
    for(int i=0;i<l1;i++){
        m1[i] = -1;
    }
    ($$).str = ($4).str; ($$).var = ($4).var; head->check(head->set($4.str,"Identifier",tp,yylineno,offset,scope,{},m1,m),$4.str); m.clear(); offset = offset + sz;
}
Final_ :
Final {m.push_back("final");}
| Final_ Final {m.push_back("final");}
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
    string sof = head->scope_name ;
    sp_offset[sof] = func_offset ;
    add_label("Return" + scope_func);
    ac.pb("leave\nret");
    ac.pb("");
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
} 
| ConstructorDeclarator ConstructorBody {
    string sof = head->scope_name ;
    sp_offset[sof] = func_offset ;
    add_label("Return" + scope_func);
    ac.pb("leave\nret");
    ac.pb("");
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers ConstructorDeclarator ConstructorBody {
    string sof = head->scope_name ;
    sp_offset[sof] = func_offset ;
    add_label("Return" + scope_func);
    ac.pb("leave\nret");
    ac.pb("");
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
} 
| ConstructorDeclarator Throws ConstructorBody {
    string sof = head->scope_name ;
    sp_offset[sof] = func_offset ;
    add_label("Return" + scope_func);
    ac.pb("leave\nret");
    ac.pb("");
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
ConstructorDeclarator:
SimpleName Lb {
    tp = THIS; sz = 0; 
    func = head->set($1.type,"Identifier",tp,yylineno,offset,scope,{},lev,m);
    m.clear();
    tables.push(head);
    string temp($1.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.type);
    scope_func = scope;
    scope += " Constructor";
    ac.pb("");
    add_label(head->scope_name);
    callee() ; 
} FormalParameterList Rb {param_offset("this", 8) ;tables.top()->check(func,$1.type);}
| SimpleName Lb Rb {
    tp = THIS;
    sz = 0;
    func = head->set($1.type,"Identifier",tp,yylineno,offset,scope,{},lev,m);
    m.clear();
    tables.push(head);
    string temp($1.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($1.type);
    scope_func = scope;
    scope += " Constructor";
    tables.top()->check(func,$1.type);
    ac.pb("");
    add_label(head->scope_name);
    callee() ;
    param_offset("this", 8) ;
    
}
|TypeParameters SimpleName Lb {tp = THIS; sz = 0; 
    func = head->set($2.type,"Identifier",tp,yylineno,offset,scope,{},lev,m);
    m.clear();
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.type);
    scope_func = scope;
    scope += " Constructor";
    ac.pb("");
    add_label(head->scope_name);
    callee();
    
} FormalParameterList Rb {tables.top()->check(func,$2.type);}
| TypeParameters SimpleName Lb Rb {
    tp = THIS;
    sz = 0;
    func = head->set($2.type,"Identifier",tp,yylineno,offset,scope,{},lev,m);
    m.clear();
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.type);
    scope_func = scope;
    scope += " Constructor";
    tables.top()->check(func,$2.type);
    ac.pb("");
    add_label(head->scope_name);
    callee();
    
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
This Lb ArgumentList Rb Semicol {
    for(int i=func_params.size()-1;i>=0;i-=1){
        add_param(func_params[i]);
    }
    func_params.clear();
    vector<Entry> c = head->get(strdup(THIS.c_str()));
    ($$).type = strdup(head->get1(c,v,head).Type.c_str());
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    if(!strlen($$.type)){
        err.push_back(yylineno);
    }
    v1.clear();
    v.clear();
}
| This Lb Rb Semicol {
    vector<Entry> c = head->get(strdup(THIS.c_str()));
    ($$).type = strdup(head->get1(c,{},head).Type.c_str());
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    v1.clear();
    v.clear();
}
| Super Lb ArgumentList Rb Semicol {
    for(int i=func_params.size()-1;i>=0;i-=1){
        add_param(func_params[i]);
    }
    func_params.clear();
    vector<Entry> c = head->parent->get($1.str);
    ($$).type = strdup(head->parent->get1(c,v,NULL).Type.c_str());
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    if(!strlen($$.type)){
        err.push_back(yylineno);
    }
    v1.clear();
    v.clear();
}
| Super Lb Rb Semicol {
    vector<Entry> c = head->parent->get($1.str);
    ($$).type = strdup(head->parent->get1(c,{},NULL).Type.c_str());
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    v1.clear();
    v.clear();
}
InterfaceDeclaration:
Modifiers Interface Identifier ExtendsInterfaces {
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Interface Identifier ExtendsInterfaces {
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{},lev,m);
    m.clear();
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
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Interface Identifier {
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Interface Identifier {
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
|Modifiers Interface Identifier TypeParameters ExtendsInterfaces {
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Interface Identifier TypeParameters ExtendsInterfaces {
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($2.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Modifiers Interface Identifier TypeParameters {
    func = head->set($3.str,"Identifier","Interface",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$3.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($3.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| Interface Identifier TypeParameters {
    func = head->set($2.str,"Identifier","Interface",yylineno,offset,scope,{},lev,m);
    m.clear();
    head->check(func,$2.str);
    tables.push(head);
    string temp($3.str);
    head = new SymbolTable(head, temp, ""); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = ($2.str);
    scope += " Interface";
} InterfaceBody {
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
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
        YYABORT;
    }
    ($$).dim1 = $1.dim1;
    ($$).type = ($1).type;
}
| VariableInitializers Comma VariableInitializer {
    $$.num = $1.num + $3.num; ($$).str = ($3).str;
    if(!compare_type(strdup(tp.c_str()),$3.type)){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = $3.dim1;
    if($1.dim1 != $$.dim1){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).type = $3.type;
}
Block:
Lcb Dummy101 BlockStatements
{
    if(flagg){
        head = tables.top();
        tables.pop();
        head->Size = offset; offset = offsets.top();
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
Type TypeArguments VariableDeclarators {m.clear();}
| Type VariableDeclarators {m.clear();}
| Final_ Type VariableDeclarators {m.clear();}
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
Assignment {$$ = $1;}
| PreIncrementExpression {$$ = $1;}
| PreDecrementExpression {$$ = $1;}
| PostIncrementExpression {$$ = $1;}
| PostDecrementExpression {$$ = $1;}
| MethodInvocation {$$ = $1;}
| ClassInstanceCreationExpression {$$ = $1;}
Dummy2:
{
    tables.push(head);
    string temp = "If";
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = head->scope_name;
    flag = true;
    add_label(head->scope_name);
}
Dummy4:
{
    string num_if = head->scope_num;
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
    tables.push(head);
    string temp = "Else";
    head = new SymbolTable(head, temp, num_if); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = head->scope_name;
    flag = true;
}
IfThenStatement:
Dummy8 Statement {
    add_label("EndIf" + head->scope_num);
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
Dummy8:
If Lb Dummy2 Expression Rb { 
    if(($4).type != "boolean"){
        cerr << "Incompatible type " << ($4).type << " instead of boolean" << endl ;
    }
    if_goto($4.var, "IfBody" + head->scope_num); go_to("EndIf" + head->scope_num); add_label("IfBody" + head->scope_num); 
}
Dummy9:
Dummy8 StatementNoShortIf {go_to("EndElse" + head->scope_num); add_label("EndIf" + head->scope_num);} Else Dummy4 {add_label(head->scope_name);}
IfThenElseStatement:
Dummy9 Statement {
    add_label("EndElse" + head->scope_num);
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
IfThenElseStatementNoShortIf:
Dummy9 StatementNoShortIf {
    add_label("EndElse" + head->scope_num);
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
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
    scope = head->scope_name;
}
SwitchStatement:
Dummy13 Lb Expression {$<s>$ = $3;} Rb SwitchBlock {
    if(!compare_type((char*)"integer", ($3).type) && strcmp(($3).type, (char*)"string")){
        cerr << ($3).type << " cannot be evaluated to type integer in the switch statement expression" << endl ;
    }
    // if(!compare_type(($3).type, ($6).type) && !compare_type1(($3).type, ($6).type)){
    //     cerr << "Incompatible types in switch statement and case label" << endl ;
    // }
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
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
SwitchBlockStatementGroup {($$).type = ($1).type ;}
| SwitchBlockStatementGroups SwitchBlockStatementGroup
SwitchBlockStatementGroup:
SwitchLabels BlockStatements {($$).type = ($1).type ;}
SwitchLabels:
SwitchLabel {($$).type = ($1).type ;}
| SwitchLabels SwitchLabel
SwitchLabel:
Case ConstantExpression Col {
    ($$).type = ($2).type ;
    if(strcmp((char*)"Integer", ($2).type) && strcmp((char*)"Character", ($2).type) && strcmp((char*)"Boolean", ($2).type) 
    && strcmp((char*)"Float", ($2).type) && strcmp((char*)"Null", ($2).type) && strcmp((char*)"Long", ($2).type) && strcmp((char*)"string", ($2).type)){
        cerr << "Case label must be of type constant expression" << endl ;
    }
}
| Default Col
Dummy1:
{
    tables.push(head);
    string temp = "While";
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = head->scope_name;
    flag = true;
    add_label(head->scope_name);
}
Dummy10:
Lb Expression Rb {
    if_goto($2.var, "WhileBody" + head->scope_num); go_to("EndWhile" + head->scope_num); add_label("WhileBody" + head->scope_num);
    if(($2).type != "boolean"){
        cerr << "While condition of type " << ($2).type << " and not Boolean" << endl ;
    }
}
WhileStatement:
While Dummy1 Dummy10 Statement {
    go_to(head->scope_name);
    add_label("EndWhile" + head->scope_num);
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
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
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
Dummy16: {
    tables.push(head);
    string temp = "DoWhile";
    head = new SymbolTable(head, temp, to_string(++varnum[temp])); list_tables.push_back(head);
    offsets.push(offset);
    offset = 0;
    scopes.push(scope);
    scope = head->scope_name;
    flag = true;
    add_label(head->scope_name);
}
Dummy17:
Do Dummy16 Statement While {add_label("DoWhileExpression" + head->scope_num);}
DoStatement:
Dummy17 Lb Expression Rb Semicol {
    if_goto($3.var, head->scope_name);
    add_label("EndDoWhile" + head->scope_num);
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
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
    scope = head->scope_name;
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
| {}
optExpression:
Expression
| {string temp = "true"; $$.var = (char *)temp.c_str();}
optForUpdate:
ForUpdate
| {}
ForStart1:
For Lb Dummy3 Final_ Type VariableDeclaratorId {head->check(head->set($6.str,"Identifier",tp,yylineno,offset,scope,{},lev,m),$6.str); m.clear(); offset = offset + sz;} Col Expression Rb
| For Lb Dummy3 Type VariableDeclaratorId {head->check(head->set($5.str,"Identifier",tp,yylineno,offset,scope,{},lev,m),$5.str); m.clear(); offset = offset + sz;} Col Expression Rb
ForStatement:
ForStart Statement {
    go_to("ForUpdate" + head->scope_num);
    add_label("EndFor" + head->scope_num);
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| ForStart1 Statement {
    go_to("ForUpdate" + head->scope_num);
    add_label("EndFor" + head->scope_num);
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
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
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
| ForStart1 StatementNoShortIf {
    go_to("ForUpdate" + head->scope_num);
    add_label("EndFor" + head->scope_num);
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
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
Break Identifier Semicol {string temp = findscope(true); go_to("End" + temp);}
| Break Semicol {string temp = findscope(true); go_to("End" + temp);}
ContinueStatement:
Continue Identifier Semicol {string temp = findscope(false); go_to(findloccont(temp));}
| Continue Semicol {string temp = findscope(false); go_to(findloccont(temp));}
ReturnStatement:
Return Expression Semicol {if(!ttt.length()){rl = yylineno; ttt = ($2).type;} string st = $2.var ; ac.pb("movq " + mp_func[st] + ", %rax") ; go_to("Return" + scope_func);}
 | Return Semicol {if(!ttt.length()){rl = yylineno; ttt = "Void";} go_to("Return" + scope_func);}
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
    scope = head->scope_name;
    flag = true;
} Lb FormalParameter Rb Block {
    head = tables.top();
    tables.pop();
    head->Size = offset; offset = offsets.top();
    offsets.pop();
    scope = scopes.top();
    scopes.pop();
}
Finally:
finally Block
Primary:
PrimaryNoNewArray {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1; ($$).var = ($1).var; ($$).ar = ($1).ar;}
| ArrayCreationExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1; ($$).var = ($1).var;}
PrimaryNoNewArray:
Bool_Literal {($$).type = (char*)"Boolean"; ($$).str = ($1).str; head->check(head->set($1.str,"Bool_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;  $$.var = $1.var; mp_func[$1.var] = $1.var; ($$).ar = 0;}
| String_Literal {($$).type = (char*)"string"; ($$).str = ($1).str; head->check(head->set($1.str,"String_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;  $$.var = $1.var; mp_func[$1.var] = $1.var; ($$).ar = 0;}
| Char_Literal {($$).type = (char*)"Character"; ($$).str = ($1).str; head->check(head->set($1.str,"Char_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;  $$.var = $1.var; mp_func[$1.var] = $1.var; ($$).ar = 0;}
| Int_Literal {($$).type = (char*)"Integer"; ($$).str = ($1).str; head->check(head->set($1.str,"Int_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;  $$.var = $1.var; string st = $1.var; mp_func[$1.var] = "$" + st ; ($$).ar = 0;}
| Tb {($$).type = (char*)"string"; ($$).str = ($1).str; head->check(head->set($1.str,"Tb",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;  $$.var = $1.var; mp_func[$1.var] = $1.var; ($$).ar = 0;}
| Float_Literal {($$).type = (char*)"Float"; ($$).str = ($1).str; head->check(head->set($1.str,"Float_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;  $$.var = $1.var; mp_func[$1.var] = $1.var; ($$).ar = 0;}
| Null_Literal {($$).type = (char*)"Null"; ($$).str = ($1).str; head->check(head->set($1.str,"Null_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;  $$.var = $1.var; mp_func[$1.var] = $1.var; ($$).ar = 0;}
| This {($$).str = strdup(THIS.c_str()); ($$).type = strdup(THIS.c_str()); ($$).dim1 = 0;  $$.var = $1.var; ($$).ar = 0;}
| Lb Expression Rb {($$).type = ($2).type; ($$).str = ($2).str; ($$).var = ($2).var ;  $$.var = $2.var; ($$).ar = 0;}
| ClassInstanceCreationExpression {($$).type = ($1).type; ($$).str = ($1).type; $$.var = $1.var; ($$).ar = 0;}
| FieldAccess {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1; $$.var = $1.var; ($$).ar = 100;
        ($$).var = build_string("@", ++varnum["arr"]);
        string st = ($$).var ;
        ac.pb("movq %rbx, " + mp_func[st]) ;
}
| MethodInvocation {($$).type = ($1).type; ($$).str = ($1).str; $$.var = $1.var; ($$).ar = 0;}
| ArrayAccess {($$).type = ($1).type; ($$).str = ($1).str; vector<Entry> c1 = head->get($$.str); map<int,int> sz1 = head->get1(c1,{},head).Dim;
    ($1).dim1 = sz1.size()-ind; ($$).dim1 = ($1).dim1; ind = 0; $$.var = $1.var;
    ac.pb("movq "+mp_func[$1.str]+", %rbx");
    ac.pb("addq %rcx, %rbx");
    ($$).var = build_string("@", ++varnum["arr"]);
    string st = ($$).var ;
    ac.pb("movq %rbx, " + mp_func[st]) ;
    ($$).ar = 100;
}

New1:
{$$.var = build_string("@", ++varnum["var"]); alloc_mem($$.var);}
ClassInstanceCreationExpression:
New ClassType New1 Lb ArgumentList Rb {
    add_param($3.var);
    for(int i=func_params.size()-1;i>=0;i-=1){
        add_param(func_params[i]);
    }
    func_params.clear();
    Entry c1;

    $$.var = $3.var ;
    call_func($$.var, $2.var); 
    if(THIS == $2.str || $2.str == "Reference Type")
        head1 = head->find_table($2.str,1);
    else
        head1 = head->find_table($2.str,0);
    if(head1){
        vector<Entry> c = head1->get($2.str);
        if(THIS == $2.str || $2.str == "Reference Type"){
            c1 = head1->get1(c,v,head1);
            ($$).type = strdup(c1.Type.c_str());
        }
        else{
            c1 = head1->get1(c,v,NULL);
            ($$).type = strdup(c1.Type.c_str());
        }
        int i = find_comma($$.type);
        ($$).type = strdup($$.type+i+1);
        if(!err.empty())
            err.pop_back();
        if(!strlen($$.type)){
            err.push_back(yylineno);
        }
    }
    else{
        cerr<<"Class mentioned in line " << yylineno << " not found"<<endl;
        YYABORT;
    }
    int sum=8;
    for(auto it:c1.Params){
        sum += get_offset(it);
    }
    v1.clear();
    v.clear();
} 
| New ClassType New1 Lb Rb {
    add_param($3.var);
    $$.var = $3.var ;
    call_func($$.var, $2.var); 
    if(THIS == $2.str || $2.str == "Reference Type") 
        head1 = head->find_table($2.str,1);
    else
        head1 = head->find_table($2.str,0);
    f3 = 0;
    vector<Entry> c = head1->get($2.str);
    if(head1){
        if(THIS == $2.str || $2.str == "Reference Type")
            ($$).type = strdup(head1->get1(c,{},head1).Type.c_str());
        else{
            ($$).type = strdup(head1->get1(c,{},NULL).Type.c_str());
        }
    }
    else{
        cerr<<"Class mentioned in line " << yylineno << " not found"<<endl;
        YYABORT;
    }
    for(auto x:c){
        if(x.Params.size()){
            err.push_back(yylineno);
            break;
        }
    }
    ($$).type = ($2).str;
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    f3 = 1;
}
| Primary Dot New ClassType New1 Lb ArgumentList Rb {
    for(int i=func_params.size()-1;i>=0;i-=1){
        add_param(func_params[i]);
    }
    func_params.clear();
    Entry c1;

    $$.var = $5.var ;
    call_func($$.var, $4.var); 
    if(THIS == $4.str || $4.str == "Reference Type")
        head1 = head->find_table($4.str,1);
    else
        head1 = head->find_table($4.str,0);
    if(head1){
        vector<Entry> c = head1->get($4.str);
        if(THIS == $4.str || $4.str == "Reference Type"){
            c1 = head1->get1(c,v,head1);
            ($$).type = strdup(c1.Type.c_str());
        }
        else{
            c1 = head1->get1(c,v,NULL);
            ($$).type = strdup(c1.Type.c_str());
        }
    }
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    if(!err.empty())
    err.pop_back();
    if(!strlen($$.type)){
        err.push_back(yylineno);
    }
    int sum=8;
    for(auto it:c1.Params){
        sum += get_offset(it);
    }
    v1.clear();
    v.clear();
} 
| Primary Dot New ClassType New1 Lb Rb {
    $$.var = $5.var ;

    call_func($$.var, $4.var); 
    if(THIS == $4.str || $4.str == "Reference Type")
        head1 = head->find_table($4.str,1);
    else
        head1 = head->find_table($4.str,0);
    f3 = 0;
    vector<Entry> c = head1->get($4.str);
    for(auto x:c){
        if(x.Params.size()){
            err.push_back(yylineno);
            break;
        }
    }
    ($$).type = ($4).str;
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    f3 = 1;
}
|New TypeArguments ClassType New1 Lb ArgumentList Rb  { 
    for(int i=func_params.size()-1;i>=0;i-=1){
        add_param(func_params[i]);
    }
    func_params.clear();
 $$.var = $4.var ; call_func($$.var, $3.var);
    int sum=8;
    for(auto it:v){
        sum += get_offset(it);
    }
     }
| New TypeArguments ClassType New1 Lb Rb { call_func($$.var, $3.var); }
|Primary Dot New TypeArguments ClassType New1 Lb ArgumentList Rb  { 
    for(int i=func_params.size()-1;i>=0;i-=1){
        add_param(func_params[i]);
    }
    func_params.clear();
 call_func($$.var, $5.var);
    int sum=8;
    for(auto it:v){
        sum += get_offset(it);
    }
    }
| Primary Dot New TypeArguments ClassType New1 Lb Rb { call_func($$.var, $5.var); }

| Name Dot New ClassType New1 Lb ArgumentList Rb {
    for(int i=func_params.size()-1;i>=0;i-=1){
        add_param(func_params[i]);
    }
    func_params.clear();
    Entry c1;

    $$.var = $5.var ;
    call_func($$.var, $4.var);
    if(THIS == $4.str || $4.str == "Reference Type")
        head1 = head->find_table($4.str,1);
    else
        head1 = head->find_table($4.str,0);
    if(head1){
        vector<Entry> c = head1->get($4.str);
        if(THIS == $4.str || $4.str == "Reference Type"){
            c1 = head1->get1(c,v,head1);
            ($$).type = strdup(c1.Type.c_str());
        }
        else{
            c1 = head1->get1(c,v,NULL);
            ($$).type = strdup(c1.Type.c_str());
        }
    }
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    if(!err.empty())
    err.pop_back();
    if(!strlen($$.type)){
        err.push_back(yylineno);
    }
    int sum=8;
    for(auto it:c1.Params){
        sum += get_offset(it);
    }
    v1.clear();
    v.clear();
} 
| Name Dot New ClassType New1 Lb Rb {
    $$.var = $5.var ;

    call_func($$.var, $4.var);
    if(THIS == $4.str || $4.str == "Reference Type")
        head1 = head->find_table($4.str,1);
    else
        head1 = head->find_table($4.str,0);
    f3 = 0;
    vector<Entry> c = head1->get($4.str);
    for(auto x:c){
        if(x.Params.size()){
            err.push_back(yylineno);
        }
    }
    ($$).type = ($4).str;
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    f3 = 1;
}
|Name Dot New TypeArguments ClassType New1 Lb ArgumentList Rb  {
    for(int i=func_params.size()-1;i>=0;i-=1){
        add_param(func_params[i]);
    }
    func_params.clear();
 call_func($$.var, $1.var);
    int sum=8;
    for(auto it:v){
        sum += get_offset(it);
    }
    }
| Name Dot New TypeArguments ClassType New1 Lb Rb { call_func($$.var, $1.var); }


|New ClassType New1 TypeArgumentsOrDiamond Lb ArgumentList Rb | New ClassType New1 TypeArgumentsOrDiamond Lb Rb
|Primary Dot New ClassType New1 TypeArgumentsOrDiamond Lb ArgumentList Rb | Primary Dot New ClassType New1 TypeArgumentsOrDiamond Lb Rb
|New TypeArguments ClassType New1 TypeArgumentsOrDiamond Lb ArgumentList Rb | New TypeArguments ClassType New1 TypeArgumentsOrDiamond Lb Rb
|Primary Dot New TypeArguments ClassType New1 TypeArgumentsOrDiamond Lb ArgumentList Rb | Primary Dot New TypeArguments ClassType New1 TypeArgumentsOrDiamond Lb Rb

|Name Dot New ClassType New1 TypeArgumentsOrDiamond Lb ArgumentList Rb | Name Dot New ClassType New1 TypeArgumentsOrDiamond Lb Rb
|Name Dot New TypeArguments ClassType New1 TypeArgumentsOrDiamond Lb ArgumentList Rb | Name Dot New TypeArguments ClassType New1 TypeArgumentsOrDiamond Lb Rb


TypeArgumentsOrDiamond : Lt Gt | TypeArguments

ArgumentList:
Expression {v.push_back($1.type); v1.push_back($1.var); func_params.pb($1.var); ($$).ar = ($1).ar;}
| ArgumentList Comma Expression {v.push_back($3.type); v1.push_back($3.var); func_params.pb($3.var);}


ArrayCreationExpression:
New PrimitiveType DimExprs Dims {($$).type = ($2).type; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); strcat($$.str,$4.str); ($$).dim1 = lev1.size(); $$.var = build_string("@", ++varnum["var"]); alloc_mem($$.var);}
| New PrimitiveType DimExprs {($$).type = ($2).type; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); ($$).dim1 = lev1.size(); $$.var = build_string("@", ++varnum["var"]); alloc_mem($$.var);}
| New ClassOrInterfaceType DimExprs Dims {($$).type = ($2).str; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); strcat($$.str,$4.str); ($$).dim1 = lev1.size(); $$.var = build_string("@", ++varnum["var"]); alloc_mem($$.var);}
| New ClassOrInterfaceType DimExprs {($$).type = ($2).str; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); ($$).dim1 = lev1.size(); $$.var = build_string("@", ++varnum["var"]); alloc_mem($$.var);}
| New PrimitiveType Dims ArrayInitializer {($$).type = ($2).type; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); strcat($$.str,$4.str); ($$).dim1 = lev1.size();
    if(lev.size()!=lev1.size()){
        cerr << "Inappropriate types in line " << yylineno<<endl;  
        YYABORT; 
    }
    $$.var = build_string("@", ++varnum["var"]); alloc_mem($$.var);
}
| New ClassOrInterfaceType Dims ArrayInitializer { ($$).type = ($2).str; ($$).str = ($1).str; strcat($$.str,$2.str); strcat($$.str,$3.str); strcat($$.str,$4.str); ($$).dim1 = lev1.size();
    if(lev.size()!=lev1.size()){
        cerr << "Inappropriate types in line " << yylineno<<endl;  
        YYABORT;
    }
    $$.var = build_string("@", ++varnum["var"]); alloc_mem($$.var);
}

DimExprs:
DimExpr
| DimExprs DimExpr
DimExpr:
Lsb Expression Rsb {f1 = 1; lev1.push_back(atoi($2.str));
    if(!compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $2.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
}
Dims:
Lsb Rsb {lev1.push_back(0);}
| Dims Lsb Rsb {lev1.push_back(0);}
FieldAccess:
Primary Dot Identifier {
    ($$).str = ($3).str; head1 = head->find_table($1.type,1); vector<Entry> c = head->get($1.str); Entry c1; if(head1){ c = head1->get($3.str); c1 = head1->get1(c,{},head1); ($$).type = strdup(c1.Type.c_str()) ; ($$).dim1 = c1.Dim.size();} else{
        cerr<<"Class mentioned in line " << yylineno << " not found"<<endl;
        YYABORT;
    }
    add_address("",mp_func["this"],to_string(c1.Offset));}
| Super Dot Identifier {($$).type = (char*)"Super"; ($$).str = ($3).str; vector<Entry> c1 = head->parent->get($$.str); map<int,int> sz1 = head->parent->get1(c1,{},head).Dim;
    ($$).dim1 = sz1.size(); add_address("",(char*)"t0", $3.var);}
Dummy14:
Primary Dot Identifier { 
    vector<Entry> c = head->get($3.str);
    Entry c1 = head->get1(c,v,head);
    if(c1.Offset==-1) {
        // offset_val = -1;
        change_ac_val = ac.size();
    }
    //add_address("", mp_func["this"], to_string(c1.Offset));
    ($$).type = ($3).str; 
    ($$).var = ($3).str;
}
Dummy15:
Super Dot Identifier { 
    vector<Entry> c = head->get($3.str);
    Entry c1 = head->get1(c,v,head);
    if(c1.Offset==-1) {
        // offset_val = -1;
        change_ac_val = ac.size();
    }
    string temp1 = build_string("#", ++varnum["var"]);
    add_assignment(temp1, to_string(c1.Offset) + " //Offset","");
    $$.var = build_string("#", ++varnum["var"]);
    add_address($$.var, "super", temp1);
    ($$).type = ($3).str; 
    }
MethodInvocation:
Name Lb ArgumentList Rb {
    if(compare_string($1.type,(char*)"println")){
        if($3.ar != 100) ac.pb("movq "+ mp_func[v1[0]] +", %rax");
        else{
            if(v1[0][0] == '@'){
                ac.pb("movq " + mp_func[v1[0]] + ", %rdx") ;
                ac.pb("movq (%rdx), %rax") ;
            }
        }
        // Print Statements
        if(print_flag%2){
            ac.pb("subq $8, %rsp") ;
        }
        ac.pb("movq %rax, %rsi");
        ac.pb("leaq .LC0(%rip), %rax");
        ac.pb("movq %rax, %rdi");
        ac.pb("movq $0, %rax");
        ac.pb("call printf@PLT");
        print_flag = 0 ;
    }
    else{
        add_param($1.var1);
        for(int i=func_params.size()-1;i>=0;i-=1){
            add_param(func_params[i]);
            func_flag = 1 ;
        }
        func_flag = 0 ;
        func_params.clear();
        if(f4){
            swap(head,head1);
        }
        Entry c1;
        $$.var = build_string("#", ++varnum["var"]); string temp($1.var); call_func($$.var, temp);
        string st = $$.var ;
        ac.pb("movq %rax, " + mp_func[st]) ;
        vector<Entry> c = head->get($1.type);
        if(THIS == $1.cl){
            c1 = head->get1(c,v,head);
            ($$).type = strdup(c1.Type.c_str());
        }
        else{
            c1 = head->get1(c,v,NULL);
            ($$).type = strdup(c1.Type.c_str());
        }
        // if(offset_val == -1)
        //     change_ac(to_string(c1.Offset));
        if(!err.empty()){
            err.pop_back();
        }
        if(!strlen($$.type)){
            err.push_back(yylineno);
        }
        int i = find_comma($$.type);
        ($$).type = strdup($$.type+i+1);
        if(f4){
            swap(head,head1);
        }
        int sum=8;
        for(auto it:c1.Params){
            sum += get_offset(it);
        }
    }
    f4 = 0;
    v.clear();
    v1.clear();
} 
| Name Lb Rb {
    if(f4){
        swap(head,head1);
    }
    add_param($1.var1);
    $$.var = build_string("#", ++varnum["var"]); string temp($1.var); call_func($$.var, temp);
    string st = $$.var ;
    ac.pb("movq %rax, " + mp_func[st]) ;
    vector<Entry> c = head->get($1.type);
    if(THIS == $1.cl)
        ($$).type = strdup(head->get1(c,v,head).Type.c_str());
    else{
        ($$).type = strdup(head->get1(c,v,NULL).Type.c_str());
    }
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    if(f4){
        swap(head,head1);
    }
    f4 = 0;
}

| Primary Dot TypeArguments Identifier Lb ArgumentList Rb 
| Primary Dot TypeArguments Identifier Lb Rb
| Super Dot TypeArguments Identifier Lb ArgumentList Rb 
| Super Dot TypeArguments Identifier Lb Rb

| Dummy14 Lb ArgumentList Rb {
    add_param("this");
    for(int i=func_params.size()-1;i>=0;i-=1){
        add_param(func_params[i]);
        func_flag = 1 ;
    }
    func_flag = 0 ;
    func_params.clear();
    $$.var = build_string("#", ++varnum["var"]); call_func($$.var, $1.var);
    string st = $$.var ;
    ac.pb("movq %rax, " + mp_func[st]) ;
    vector<Entry> c = head->get($1.type);
    Entry c1 = head->get1(c,v,head);
    // if(offset_val == -1)
    //     change_ac(to_string(c1.Offset));
    ($$).type = strdup(c1.Type.c_str());
    if(!err.empty())
        err.pop_back();
    if(!strlen($$.type)){
        err.push_back(yylineno);
    }
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    int sum=8;
    for(auto it:v){
        sum += get_offset(it);
    }
    v.clear();
    v1.clear();
}
| Dummy14 Lb Rb {
    add_param("this");
    $$.var = build_string("#", ++varnum["var"]); call_func($$.var, $1.var);
    string st = $$.var ;
    ac.pb("movq %rax, " + mp_func[st]) ;
    vector<Entry> c = head->get($1.type);
    ($$).type = strdup(head->get1(c,{},NULL).Type.c_str());
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
}
| Dummy15 Lb ArgumentList Rb {
    for(int i=func_params.size()-1;i>=0;i-=1){
        add_param(func_params[i]);
        func_flag = 1 ;
    }
    func_flag = 0 ;
    func_params.clear();
    $$.var = build_string("#", ++varnum["var"]); call_func($$.var, $1.var);
    string st = $$.var ;
    ac.pb("movq %rax, " + mp_func[st]) ;
    vector<Entry> c = head->parent->get($1.type);
    Entry c1 = head->parent->get1(c,v,NULL);
    ($$).type = strdup(c1.Type.c_str());
    // if(offset_val == -1)
    //     change_ac(to_string(c1.Offset));
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
    if(!err.empty())
    err.pop_back();
    if(!strlen($$.type)){
        err.push_back(yylineno);
    }
    int sum=8;
    for(auto it:v){
        sum += get_offset(it);
    }
    v.clear();
    v1.clear();
} 
| Dummy15 Lb Rb {
    $$.var = build_string("#", ++varnum["var"]); call_func($$.var, $1.var);
    string st = $$.var ;
    ac.pb("movq %rax, " + mp_func[st]) ;
    vector<Entry> c = head->parent->get($1.type);
    Entry c1 = head->parent->get1(c,{},head->parent);
    // if(offset_val == -1)
    //     change_ac(to_string(c1.Offset));
    ($$).type = strdup(c1.Type.c_str());
    int i = find_comma($$.type);
    ($$).type = strdup($$.type+i+1);
}
ArrayAccess:
Name Lsb Expression Rsb {
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    vector<Entry> c = head->get($1.type);
    Entry c1 = head->get1(c,{},head);
    stack<int> s = c1.refine_dim();
    lev2.clear() ;
    while(!s.empty()){
        prod *= s.top();
        lev2.push_back(s.top());
        s.pop();
    }
    prod /= lev2[ind++];
    ($$).type = ($1).str;
    ($$).str = ($1).type; 
    ac.pb("movq $0, %rcx");
    add_address1($1.var, $3.var, prod, $3.str);
}
| ArrayAccess Lsb Expression Rsb {
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    prod /= lev2[ind++];
    ($$).str = ($1).str; 
    ($$).type = ($1).type;
    add_address1($1.var, $3.var, prod, $3.str);
}
| Bool_Literal Lsb Expression Rsb {($$).type = (char*)"Boolean"; ($$).str = ($1).str; head->check(head->set($1.str,"Bool_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1($1.var, $3.var, prod, $3.str);
}
| String_Literal Lsb Expression Rsb {($$).type = (char*)"string"; ($$).str = ($1).str; head->check(head->set($1.str,"String_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1($1.var, $3.var, prod, $3.str);
}
| Char_Literal Lsb Expression Rsb {($$).type = (char*)"Character"; ($$).str = ($1).str; head->check(head->set($1.str,"Char_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1($1.var, $3.var, prod, $3.str);
}
| Int_Literal Lsb Expression Rsb {($$).type = (char*)"Integer"; ($$).str = ($1).str; head->check(head->set($1.str,"Int_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1($1.var, $3.var, prod, $3.str);
}
| Tb Lsb Expression Rsb {($$).type = (char*)"string"; ($$).str = ($1).str; head->check(head->set($1.str,"Tb",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1($1.var, $3.var, prod, $3.str);
}
| Float_Literal Lsb Expression Rsb {($$).type = (char*)"Float"; ($$).str = ($1).str; head->check(head->set($1.str,"Float_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1($1.var, $3.var, prod, $3.str);
}
| Null_Literal Lsb Expression Rsb {($$).type = (char*)"Null"; ($$).str = ($1).str; head->check(head->set($1.str,"Null_Literal",$$.type,yylineno,offset,scope,{},{},m),$1.str); ($$).dim1 = 0;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1($1.var, $3.var, prod, $3.str);
}
| This Lsb Expression Rsb {($$).str = strdup(THIS.c_str());
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1("t0", $3.var, prod, $3.str);
}
| Lb Expression Rb Lsb Expression Rsb {($$).type = ($2).type; ($$).str = ($2).str;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
}
| ClassInstanceCreationExpression Lsb Expression Rsb {
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1($1.var, $3.var, prod, $3.str);
}
| FieldAccess Lsb Expression Rsb {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1($1.var, $3.var, prod, $3.str);
}
| MethodInvocation Lsb Expression Rsb {($$).type = ($1).type; ($$).str = ($1).str;
    if(!compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"integer")){
        cerr << "Array index cannot be of type " << $3.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    ind++;
    add_address1($1.var, $3.var, prod, $3.str);
}

PostfixExpression:
Primary {($$).type = ($1).type; ($$).var = ($1).var ; ($$).str = ($1).str; ($$).ar = ($1).ar;}
| Name {($$).type = ($1).str; ($$).var = ($1).var ; ($$).str = ($1).type; ($$).ar = 0;
    if($1.ar == 100){
        ($$).ar = 100;
        ($$).var = build_string("@", ++varnum["arr"]);
        string st = ($$).var ;
        ac.pb("movq %rbx, " + mp_func[st]) ;
    }
}
| PostIncrementExpression {($$).type = ($1).type; ($$).var = ($1).var ; ($$).str = ($1).str;}
| PostDecrementExpression {($$).type = ($1).type; ($$).var = ($1).var ; ($$).str = ($1).str;}
PostIncrementExpression:
PostfixExpression Inc {
    if(!compare_string($1.type,(char*)"float") && !compare_string($1.type,(char*)"double") && !compare_string($1.type,(char*)"long") && !compare_string($1.type,(char*)"integer") && !compare_string($1.type,(char*)"short") && !compare_string($1.type,(char*)"character") && !compare_string($1.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$2.str<< " with operand of type "<< $1.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    if($1.dim1!=0){
        cerr << "Incompatible Operator " <<$2.str<< " in line " << yylineno<<endl;
        YYABORT;
    }
    $$ = $1 ;
    $$.var = build_string("#", ++varnum["var"]) ;
    mp_func["1"] = "$1";
    add_assignment($$.var, $1.var,$1.str) ;
    add_string($1.var, $1.var, "1", "+");
    head->counter($1.str);

}
PostDecrementExpression:
PostfixExpression Dec {
    if(!compare_string($1.type,(char*)"float") && !compare_string($1.type,(char*)"double") && !compare_string($1.type,(char*)"long") && !compare_string($1.type,(char*)"integer") && !compare_string($1.type,(char*)"short") && !compare_string($1.type,(char*)"character") && !compare_string($1.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$2.str<< " with operand of type "<< $1.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    if($1.dim1!=0){
        cerr << "Incompatible Operator " <<$2.str<< " in line " << yylineno<<endl;
        YYABORT;
    }
    $$ = $1 ;
    $$.var = build_string("#", ++varnum["var"]) ;
    add_assignment($$.var, $1.var,$1.str) ;
    mp_func["1"] = "$1";
    add_string($1.var, $1.var, "1", "-");
    head->counter($1.str);
}
UnaryExpression:
PreIncrementExpression
| PreDecrementExpression
| Plus UnaryExpression { 
    $$ = $2;
    if(!compare_string($2.type,(char*)"float") && !compare_string($2.type,(char*)"double") && !compare_string($2.type,(char*)"long") && !compare_string($2.type,(char*)"integer") && !compare_string($2.type,(char*)"short") && !compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$1.str<< " with operand of type "<< $2.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    if($2.dim1!=0){
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
        YYABORT;
    }
}
| Minus UnaryExpression {
     $$ = $2; ($$).var = build_string("#", ++varnum["var"]); add_unary($$.var, $2.var, "-");
     if(!compare_string($2.type,(char*)"float") && !compare_string($2.type,(char*)"double") && !compare_string($2.type,(char*)"long") && !compare_string($2.type,(char*)"integer") && !compare_string($2.type,(char*)"short") && !compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$1.str<< " with operand of type "<< $2.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    if($2.dim1!=0){
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
        YYABORT;
    }
}
| UnaryExpressionNotPlusMinus {($$).type = ($1).type; ($$).var = ($1).var ; ($$).str = ($1).str;}
PreIncrementExpression:
Inc UnaryExpression {
    if(!compare_string($2.type,(char*)"float") && !compare_string($2.type,(char*)"double") && !compare_string($2.type,(char*)"long") && !compare_string($2.type,(char*)"integer") && !compare_string($2.type,(char*)"short") && !compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$1.str<< " with operand of type "<< $2.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    if($2.dim1!=0){
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
        YYABORT;
    }
    mp_func["1"] = "$1";
    add_string($2.var, $2.var, "1", "+"); $$ = $2;
    head->counter($1.str);
}
PreDecrementExpression:
Dec UnaryExpression {
    if(!compare_string($2.type,(char*)"float") && !compare_string($2.type,(char*)"double") && !compare_string($2.type,(char*)"long") && !compare_string($2.type,(char*)"integer") && !compare_string($2.type,(char*)"short") && !compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$1.str<< " with operand of type "<< $2.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    if($2.dim1!=0){
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
        YYABORT;
    }
    mp_func["1"] = "$1";
    add_string($2.var, $2.var, "1", "-"); $$ = $2;
    head->counter($1.str);
}
UnaryExpressionNotPlusMinus:
PostfixExpression {($$).type = ($1).type; ($$).var = ($1).var ; ($$).str = ($1).str; ($$).ar = ($1).ar;}
| Tilde UnaryExpression {
    $$ = $2; ($$).var = build_string("#", ++varnum["var"]); add_unary($$.var, $2.var, $1.var);
    if(!compare_string($2.type,(char*)"long") && !compare_string($2.type,(char*)"integer") && !compare_string($2.type,(char*)"short") && !compare_string($2.type,(char*)"character") && !compare_string($2.type,(char*)"byte")){
        cerr << "Incompatible Operator " <<$1.str<< " with operand of type "<< $2.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    if($2.dim1!=0){
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
        YYABORT;
    }
}
| Not UnaryExpression {
    $$ = $2; ($$).var = build_string("#", ++varnum["var"]); add_unary($$.var, $2.var, $1.var);
    if(!compare_string($2.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$1.str<< " with operand of type "<< $2.type << " in line " << yylineno<<endl;
        YYABORT;
    } 
    if($2.dim1!=0){
        cerr << "Incompatible Operator " <<$1.str<< " in line " << yylineno<<endl;
        YYABORT;
    }
}
| CastExpression {($$).type = ($1).type; ($$).var = ($1).var ; ($$).str = ($1).str;}
MultiplicativeExpression:
UnaryExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).var = ($1).var ; ($$).ar = ($1).ar;}
| MultiplicativeExpression Mult UnaryExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
| MultiplicativeExpression Div UnaryExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
| MultiplicativeExpression Mod UnaryExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
AdditiveExpression:
MultiplicativeExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).var = ($1).var ; ($$).ar = ($1).ar;}
| AdditiveExpression Plus MultiplicativeExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
| AdditiveExpression Minus MultiplicativeExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
ShiftExpression:
AdditiveExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).ar = ($1).ar;}
| ShiftExpression Shifter AdditiveExpression { 
    if((!compare_string($1.type,(char*)"long") && !compare_string($1.type,(char*)"integer") && !compare_string($1.type,(char*)"short") && !compare_string($1.type,(char*)"character") && !compare_string($1.type,(char*)"byte")) ||
       (!compare_string($3.type,(char*)"long") && !compare_string($3.type,(char*)"integer") && !compare_string($3.type,(char*)"short") && !compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"byte"))
    || (!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type))){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
RelationalExpression:
ShiftExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).ar = ($1).ar;}
| RelationalExpression Lt ShiftExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_bool(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_bool(($$).var, s2, ($3).var, s1);
    }
    else add_bool(($$).var, ($1).var, ($3).var, s1);
    ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
| RelationalExpression Gt ShiftExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_bool(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_bool(($$).var, s2, ($3).var, s1);
    }
    else add_bool(($$).var, ($1).var, ($3).var, s1);
    ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
| RelationalExpression Relop ShiftExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if(compare_string($1.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_bool(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_bool(($$).var, s2, ($3).var, s1);
    }
    else add_bool(($$).var, ($1).var, ($3).var, s1);
    ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
| RelationalExpression Instanceof ReferenceType
EqualityExpression:
RelationalExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).ar = ($1).ar; $$.var = $1.var;}
| EqualityExpression Eqnq RelationalExpression { 
    if(!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type)){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_bool(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_bool(($$).var, s2, ($3).var, s1);
    }
    else add_bool(($$).var, ($1).var, ($3).var, s1);
    ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
AndExpression:
EqualityExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).ar = ($1).ar;}
| AndExpression And EqualityExpression {
    if((!compare_string($1.type,(char*)"long") && !compare_string($1.type,(char*)"integer") && !compare_string($1.type,(char*)"short") && !compare_string($1.type,(char*)"character") && !compare_string($1.type,(char*)"byte") && !compare_string($1.type,(char*)"boolean")) ||
       (!compare_string($3.type,(char*)"long") && !compare_string($3.type,(char*)"integer") && !compare_string($3.type,(char*)"short") && !compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"byte") && !compare_string($3.type,(char*)"boolean"))
    || (!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type))){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
ExclusiveOrExpression:
AndExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).ar = ($1).ar;}
| ExclusiveOrExpression Xor AndExpression {
    if((!compare_string($1.type,(char*)"long") && !compare_string($1.type,(char*)"integer") && !compare_string($1.type,(char*)"short") && !compare_string($1.type,(char*)"character") && !compare_string($1.type,(char*)"byte") && !compare_string($1.type,(char*)"boolean")) ||
       (!compare_string($3.type,(char*)"long") && !compare_string($3.type,(char*)"integer") && !compare_string($3.type,(char*)"short") && !compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"byte") && !compare_string($3.type,(char*)"boolean"))
    || (!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type))){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
InclusiveOrExpression:
ExclusiveOrExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).ar = ($1).ar;}
| InclusiveOrExpression Or ExclusiveOrExpression {
    if((!compare_string($1.type,(char*)"long") && !compare_string($1.type,(char*)"integer") && !compare_string($1.type,(char*)"short") && !compare_string($1.type,(char*)"character") && !compare_string($1.type,(char*)"byte") && !compare_string($1.type,(char*)"boolean")) ||
       (!compare_string($3.type,(char*)"long") && !compare_string($3.type,(char*)"integer") && !compare_string($3.type,(char*)"short") && !compare_string($3.type,(char*)"character") && !compare_string($3.type,(char*)"byte") && !compare_string($3.type,(char*)"boolean"))
    || (!compare_type($1.type,$3.type) && !compare_type($3.type,$1.type))){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = ($2).str ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = widen(($1).type,($3).type); ($$).str = ($3).str;
}
ConditionalAndExpression:
InclusiveOrExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).ar = ($1).ar;}
| ConditionalAndExpression Bool_and InclusiveOrExpression {
    if(!compare_type($1.type,(char*)"boolean") || !compare_type($3.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = "*" ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
ConditionalOrExpression:
ConditionalAndExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).ar = ($1).ar;}
| ConditionalOrExpression Bool_or ConditionalAndExpression {
    if(!compare_type($1.type,(char*)"boolean") || !compare_type($3.type,(char*)"boolean")){
        cerr << "Incompatible Operator " <<$2.str<< " with operands of types "<< $1.type << " and "<< $3.type << " in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=$3.dim1 || $1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
    }
    ($$).dim1 = ($3).dim1; 
    ($$).var = build_string("#", ++varnum["var"]);
    string s1 = "+" ;
    string temp = widen(($1).type,($3).type);
    s1 = s1 + temp ;
    string s2 ;
    int check_type = widen2(($1).type,($3).type) ;
    if(check_type == 1){
        string s2 = Type_cast(($1).type, ($3).var) ;
        add_string(($$).var, ($1).var, s2, s1);
    }
    else if(check_type == 0){
        string s2 = Type_cast(($3).type, ($1).var) ;
        add_string(($$).var, s2, ($3).var, s1);
    }
    else add_string(($$).var, ($1).var, ($3).var, s1);
    ($$).type = (char*)"boolean"; ($$).str = ($3).str;
}
Dummy18:
ConditionalOrExpression Qm {$$ = $1; $$.num = ++varnum["ternary"]; string tern_num = to_string($$.num); $$.var = (char *)tern_num.c_str();
if_goto($1.var, "TernaryFirst" + tern_num); go_to("TernarySecond" + tern_num); add_label("TernaryFirst" + tern_num);}
Dummy19:
Dummy18 Expression Col {$$ = $1; string tern_num = to_string($1.num); add_assignment("t_op" + tern_num, $2.var,$2.str); go_to("EndTernary" + tern_num); add_label("TernarySecond" + tern_num);}
ConditionalExpression:
ConditionalOrExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1; ($$).ar = ($1).ar;}
| Dummy19 ConditionalExpression {
    if(!compare_type($1.type,(char*)"boolean")){
        cerr << "Incompatible Ternary Operator with the given operands in line " << yylineno<<endl;
        YYABORT;
    }
    if($1.dim1!=0){
        cerr << "Types do not match inside the array in line " << yylineno<<endl;
        YYABORT;
    }
    $$.type = $2.type;
    $$.num = $1.num;
    string tern_num =  to_string($1.num);
    add_assignment("t_op" + tern_num, $2.var,$2.str);
    add_label("EndTernary" + tern_num);
    $$.var = (char *)("t_op" + tern_num).c_str();
}
AssignmentExpression:
ConditionalExpression {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1; ($$).var = ($1).var; ($$).ar = ($1).ar;}
| Assignment {($$).type = ($1).type; ($$).str = ($1).str; ($$).dim1 = ($1).dim1; ($$).var = ($1).var;}
Assignment:
LeftHandSide Eq AssignmentExpression {
    if(!compare_type($1.type,$3.type) && !compare_type1($1.type,$3.type)){
        cerr << "Types do not match on both the sides in line " << yylineno<<endl;
        YYABORT;
    }
    else{
            if($1.dim1 != $3.dim1){
                cerr << "Types do not match inside the array in line " << yylineno<<endl;
                YYABORT;
            }
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
                head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},m1,m); offset = offset + 8;
            }
            ($$).type = widen(($1).type,($3).type);
            ($$).str = ($1).str;
            $$.dim1 = $1.dim1;
    }
    lev.clear(); l1 = 0;
    int check_type = widen2(($1).type,($3).type);
    if(check_type != -1){
        string s1 ;
        if(check_literal($3.type)){s1 = Type_cast($1.type, strdup(mp_func[$3.var].c_str()));}
        else{s1 = Type_cast($1.type, $3.var);}
        string s2 = build_string("#", ++varnum["var"]) ;
        add_assignment(s2, s1,$1.str);
        if(mp_func[$1.var].length() == 0){
            mp_func[$1.var] = local_offset(get_offset($1.type)) ;
            add_assignment($1.var, s2,$1.str) ;
        }
        else add_assignment($1.var, s2,$1.str) ;
    }
    else{
        string sarr = $3.var ;
        if(mp_func[$1.var].length() == 0){
            if(sarr[0] == '@') {mp_func[$1.var] = "-" + to_string(func_offset) + "(%rbp)" ;}
            else{
                mp_func[$1.var] = local_offset(get_offset($1.type)) ;
                add_assignment($1.var, sarr,$1.str) ;
            }
        }
        else{
            add_assignment($1.var, sarr,$1.str) ;
        }
    }
    vector<Entry>* c2 ;
                for(auto ptr=head; ptr!=NULL; ptr=ptr->parent){
                    if(ptr->table.find($1.str)!=ptr->table.end()){
                        c2 = &ptr->table[$1.str];
                        break ;
                    }
                }
                if(c2){
                Entry* c3 ;
                for(int j=0; j<(*c2).size(); j++){
                    if((*c2)[j].Params.size()!=0 || find((*c2)[j].Mod.begin(),(*c2)[j].Mod.end(),"private")!=(*c2)[j].Mod.end())
                        continue;
                    int final_flag = 1;
                    for(int i=0;i<v.size();i++){
                        if(!compare_type(strdup((*c2)[j].Params[i].c_str()),strdup(v[i].c_str()))){
                            final_flag = 0;
                            break;
                        }
                    }
                    if(final_flag == 1){
                        c3 = &(*c2)[j] ;
                        break ;
                    }
                }
                if(c3){
                    c3->final_check++ ;
                        if(c3->final_check > 1 && find(c3->Mod.begin(), c3->Mod.end(), "final") != c3->Mod.end()){
                        cerr << "Variable of type final cannot be modified in line " << yylineno << endl ;
                        }
                }
    }
     lev1.clear();
}
| 
LeftHandSide Eqq AssignmentExpression {
    if(!compare_type($1.type,$3.type) && !compare_type1($1.type,$3.type)){
        cerr << "Types do not match on both the sides in line " << yylineno<<endl;
        YYABORT;
    }
    else{
            if($1.dim1 != $3.dim1){
                cerr << "Types do not match inside the array in line " << yylineno<<endl;
                YYABORT;
            }
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
                head->set($1.str,"Identifier",tp,yylineno,offset,scope,{},m1,m); offset = offset + 8;
            }
            ($$).type = widen(($1).type,($3).type);
            ($$).str = ($1).str;
            $$.dim1 = $1.dim1;
    }
    lev.clear(); l1 = 0;
    string temp2($2.var), temp3;
    if(check_literal($3.type)) temp3 = mp_func[$3.var] ;
    else temp3 = $3.var ;
    temp2.pop_back();
    add_string($1.var, $1.var, $3.var, temp2) ;
    vector<Entry>* c2 ;
                for(auto ptr=head; ptr!=NULL; ptr=ptr->parent){
                    if(ptr->table.find($1.str)!=ptr->table.end()){
                        c2 = &ptr->table[$1.str];
                        break ;
                    }
                }
                if(c2){
                Entry* c3 ;
                for(int j=0; j<(*c2).size(); j++){
                    if((*c2)[j].Params.size()!=0 || find((*c2)[j].Mod.begin(),(*c2)[j].Mod.end(),"private")!=(*c2)[j].Mod.end())
                        continue;
                    int final_flag = 1;
                    for(int i=0;i<v.size();i++){
                        if(!compare_type(strdup((*c2)[j].Params[i].c_str()),strdup(v[i].c_str()))){
                            final_flag = 0;
                            break;
                        }
                    }
                    if(final_flag == 1){
                        c3 = &(*c2)[j] ;
                        break ;
                    }
                }
                if(c3){
                    c3->final_check++ ;
                        if(c3->final_check > 1 && find(c3->Mod.begin(), c3->Mod.end(), "final") != c3->Mod.end()){
                        cerr << "Variable of type final cannot be modified in line " << yylineno << endl ;
                        }
                }
    }
     lev1.clear();
}
LeftHandSide:
Name {($$).type = ($1).str; ($$).str = ($1).type; ($$).dim1 = ($1).dim1;
    if($1.ar==100){
        ff1=1;
        ac.pb("movq %rbx, %r12");
    }
}
|FieldAccess {($$).type = ($1).type; ($$).dim1 = ($1).dim1;
ff1 = 1;
ac.pb("movq %rbx, %r12");
}
|ArrayAccess {
    ($$).type = ($1).type; vector<Entry> c1 = head->get($$.str); map<int,int> sz1 = head->get1(c1,{},head).Dim;
    ($1).dim1 = sz1.size()-ind; ($$).dim1 = ($1).dim1; ind = 0; ff = 1;
    ac.pb("movq "+mp_func[$1.str]+", %r8");
    ac.pb("addq %rcx, %r8");
}
Expression:
AssignmentExpression {$$=$1;}
ConstantExpression:
Expression //{($$).type = ($1).type; ($$).str = ($1).str;}
TypeParameters: Lt TypeParameterList Gt {($$).type = ($1).str; strcat(($$).type,($2).type); strcat(($$).type,($3).str); tpp = ($$).type;}
TypeParameterList:
 TypeParameter //{($$).type = ($1).type;}
 | TypeParameter Comma TypeParameterList {($$).type = ($1).type; strcat(($$).type,($2).str); strcat(($$).type,($3).type);}
 | TypeParameter Comma TypeParameters {($$).type = ($1).type; strcat(($$).type,($2).str); strcat(($$).type,($3).type);}
TypeParameter : Identifier TypeBound {($$).type = ($1).str;}
TypeBound : {} | Extends ClassOrInterfaceType AdditionalBounds;
AdditionalBounds: {} | AdditionalBounds AdditionalBound
AdditionalBound : And InterfaceType;
%%

int main(int argc, char* argv[]){
    mp_func["%r13"] = "%r13";
    mp_func["%r14"] = "%r14";
    mp_func["%r15"] = "%r15";
    mp_func["1"] = "$1";
    list_tables[0] = head;
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
    char* input_filename = nullptr;
    int opt;
    while ((opt = getopt_long(argc, argv, "i:hv", long_options, nullptr)) != -1) {
        switch (opt) {
        case 'i':
            input_filename = optarg;
            break;
        case 'h':
            std::cout << "Usage: " << argv[0] << " [OPTIONS]\n"
                      << "Options:\n"
                      << "  -i, --input FILENAME   Set input file\n"
                      << "  -h, --help             Display this help message\n"
                      << "  -v, --verbose          Enable verbose mode\n"
                      << std::endl;
            return 0;
        case 'v':
            verbose = true;
            break;
        case '?':
            return 1;
        default:
            std::cerr << "Internal error: unhandled option " << opt << std::endl;
            return 1;
        }
    }
    if (input_filename == nullptr) {
        std::cerr << "Error: input filename is required" << std::endl;
        return 1;
    }
    if (verbose) {
        #if YYDEBUG
            yydebug = 1 ;
        #endif
    }
    yyin = fopen(input_filename, "r");
    yyparse();
    if(!err.empty()){
        cerr << "Incorrect Invocation in line " << err[0]<<endl; 
    }
    // for(auto x:list_tables){
    //     ofstream sy (csv_name(), std::ofstream::out);
    //     x->print();
    //     sy << symtable ;
    //     symtable = "" ;
    // }
    ofstream ac3 ("x86_code.s", std::ofstream::out);
    ac3 << ".section    .rodata" << endl ;
    ac3 << ".LC0:" << endl ;
    ac3 << "     .string    \"%d\\n\"" << endl ;
    ac3 << "     .text" << endl ;
    ac3 << "     .globl    main" << endl ;
    int i ;
    for(i=0; i<ac.size(); i++) {
        if(ac[i][ac[i].size() - 1] == '*'){
            ac3 << ac[i].substr(0, ac[i].size() - 1) << endl ;
            ac3 << "subq $" + to_string(nearestPowerOf2(sp_offset[ac[i-1].substr(0, ac[i-1].size() - 1)])) + ", %rsp" << endl ;
        }
        else {
            if(ac[i] == "main:") {
                ac3 << ac[i] << endl;
                for(auto itr : sta_ac) {
                    ac3 << "\t" << itr << endl;
                }
            }
            else if(ac[i][ac[i].size() - 1] == ':')
                ac3 << ac[i] << endl;
            else
                ac3 << "\t" << ac[i] << endl;
        }
    }
    return 0;
}

int yyerror(const char *s) {
    cerr<<s<<" in line number "<<yylineno<<endl;
    return 0;
}