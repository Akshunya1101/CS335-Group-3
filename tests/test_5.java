public class Main
{
        int x ;
        int y ;
        int z ;
        Main(){
        }
        int sum1(int x){
            return 500;
        }
        int sum(int a){
            x = 2;
            a = this.sum1(0);
            return a ;
        }
	public static void main() {
        Main obj = new Main() ;
        obj.x = 6 ;
        obj.y = 9;
        int d = 5;
        d = obj.sum(2) ;
        System.out.println(d) ;
        return ;
	}
}