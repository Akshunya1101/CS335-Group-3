public class test {
    public class A{
        int x;
        float y ;
        A(int y){
            
        }
        int re(int x,float y){
            return 1;
        }
    }
    //Check for String[]
	public static void main(int args) {
        A q = new A('c');
        int z = q.re(2,3);
        z = q.a ;
        z = q.y ;
        z = (int)q.y ;
        int b = A.add(2,3) ;// not declared so error
        A r = new B(2) ;
        C r = new C(1) ;

	    return;
	}
}