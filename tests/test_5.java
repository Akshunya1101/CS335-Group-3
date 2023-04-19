public class Main
{
	public static void main() {
        int k = 5;
        int arr[][] = new int[20][5];
        int a = 19, b = 4, c = 3 ;
        arr[1][1] = 20;
        arr[0][0] = 3;
        arr[a][b] = arr[a-18][b-3]*arr[a-19][c-3] ;
        System.out.println(arr[1][1]+20);
	}
}