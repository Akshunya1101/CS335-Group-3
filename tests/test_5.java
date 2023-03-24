public class Main
{
	public static void main(int args) {
	    int [][][] arr1 = {{{1,2}, {4,5}, {2,3}}} ;
        int arr2[][] = {{3}} ;
        int arr3[] = {1, 2} ;
        char arr5 [] = {'a', 'b', 'c'} ;
        float arr6 [][] = {{1.2, 1.1}} ;
        int arr7 [][] ;
        arr7 = new int [2][3] ;
        arr2[0][0] = arr1[0][0][0] ;
        arr2 = arr1[0] ;
        arr2[0] = arr3 ;
        arr3[0] = (int) arr6[0][1] ;
        return ;
	}
}