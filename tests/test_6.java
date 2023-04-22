//This is a test case to test that there is
//no upper limit on the numbe of arguments we can pass to a function
public class Main {
    int x;
    int y;
    public static int sum(int arg1, int arg2, int arg3, int arg4, int arg5, 
                      int arg6, int arg7, int arg8, int arg9, int arg10,
                      int arg11, int arg12, int arg13, int arg14, int arg15,
                      int arg16, int arg17, int arg18, int arg19, int arg20, int arg21) {
    int result = arg1 + arg2 + arg3 + arg4 + arg5 + arg6 + arg7 + arg8 + arg9 + arg10
                + arg11 + arg12 + arg13 + arg14 + arg15 + arg16 + arg17 + arg18 + arg19 + arg20 + arg21;
    return result;
}


    void main(int args){
        int total = sum(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21);
        System.out.println(total);
    }
}