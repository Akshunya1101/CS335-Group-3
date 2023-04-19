public class Main
{
	public static void main() {
        int k = 5;
        int arr[][] = new int[20][20];
        int arr1[][] = new int[10][10];
        int a = 19, b = 4, c = 3 ;
        arr[1][1] = 20;
        System.out.println(arr[1][1]);
        arr[0][0] = 3;
        System.out.println(arr[0][0]);
        arr1[0][0] = 2;
        System.out.println(arr1[0][0]);
        arr[a][b] = arr[a-18][b-3]*arr[a-19][c-3] ;
        System.out.println(arr[a][b]);
	}
}