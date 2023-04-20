public class Main
{
        int x ;
        int y ;
        int z ;
        Main(int x,int y){
            this.x = 2*x;
            this.y = 2*y;
        }
        int sum(int a){
            x = 4;
            return 0;
        }
	public static void main() {
        int arr[] = new int[5];
        arr[4] = 10;
        Main obj = new Main(2,4);
        arr[3] = obj.x + obj.y*obj.x;
        Main obj1 = new Main(2,4);
        arr[2] = arr[3]*obj.x + 5;
        int x=10;
        int arr1[] = new int[15];
        arr1[8] = obj1.y*arr[3] + 10;
        //System.out.println(arr1[8]);
        int y = obj1.sum(0);
        //System.out.println(obj1.y);
        arr1[7]=arr[4];
        System.out.println(arr1[7]);
	}
}