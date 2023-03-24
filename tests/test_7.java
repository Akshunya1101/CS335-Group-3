public class Main
{
    public static int add(int x, int y){
        return x+y ;
    }
    public static float add(float x, float y){
        return x+y ;
    }
	public static void main(int args) {
        int x = add(2,3) ;
        float y = add(1.2, 3.4) ;
        // no. of parameters incorrect
        int x = add(2) ;
        return ;
	}
}
