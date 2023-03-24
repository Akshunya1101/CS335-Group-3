public class test {
    public class A{
        final int x = 1;
        A(int y){
            
        }
        int re(int x,float y){
            return 1;
        }
    }
    //Check for String[]
	public static void main(int args) {
        A q = new A('c');
        int w = q.x ;
        int z = q.re(2,3);
	    return;
	}
}