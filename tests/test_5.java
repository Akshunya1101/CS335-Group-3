public class Main
{
        int x ;
        int y ;
        Main(){
        }
        int sum(int a, int b){
            return a + b ;
        }
	public static void main() {
        Main obj = new Main() ;
        obj.x = 1 ;
        obj.y = 5 ;
        int d = obj.sum(2, 3) ;
        System.out.println(d+2*d);
        return ;
	}
}