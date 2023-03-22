public class test {
    class String{

    }
    //Check for String[]
	public static void main(int args) {
	    int [][][] arr1 = {{{1,2}, {4,5}, {2,3}}} ;
        int arr2[][] = {{3}} ;
        int arr3[] = {1, 2} ;
        int arr4[] = {2,3} ;
        char arr5 [] = {'a', 'b', 'c'} ;
        float arr6 [][] = {{1.2, 1.1}} ;
        arr2 = arr1[0] ;
        arr3[0] = (int) arr5[1] ;
        arr2[0][0] = (int)arr3[0] ;
        arr1[0] = arr2 ;
        arr3[0] = 2 ;
        int y = 2 ;
        arr1[2][3] = arr2[0] = arr3 ;
        arr2[1][2] = arr3[0] = y ;
        int x = 3 ;
        arr1[2][3][1] = x ;
        arr3 = arr2[1] ;
        arr3 = arr4 ;
        arr1[3] = (int) arr2 ;
        arr6 = arr2 ;
        arr6[1] = arr1[0][0] ;
        arr2[1] = (int)arr6 [1] ;
        arr3[0] = (int) arr6[0][0] ;
        int xxx = (int) arr6[0][0] ;
        arr3[0] = arr5[0] ;
        boolean z = arr1[3][3][0] > arr1[0][0][0] ;
        //Errorenous Cases
        /*int arr7 [][] = {{arr2},{1}} ;
        arr3[0] = arr6[0][0] ;
        arr3[0] = (int) arr5 ;
        arr1[1] = (int) arr2[1] ;
        arr2[0] = arr1[1] ;
        arr1[0][1] = arr2 ;
        arr1 = arr2 ;
        arr3 = arr1[0] ;
        arr2 = arr3[0] ;
        arr2[0] = arr3 = arr4[1] ;
        arr2[0] = arr4[1] = arr3 ;
        arr2[1] = arr6[1] ;
        arr2[1] = (int) arr6 ;*/


        return ;


	}
}