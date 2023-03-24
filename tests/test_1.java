public class Main
{
    public static int add(int x, int y, int z, float y){
        return x+y ;
    }
	public static void main(int args) {
        int x = 1 ;
        float y = x ;
        char c = 4 ;
        c = 1 ;
        c = (char)y ;
        x = (int)y ;
        x = (int)1.1 ;
        float z = x + y + c ;
        int a = add(x, x, x, y) ;
        boolean b = x > 2 ;
        return ;
	}
}
