public class test_1 {
    int x;
    int y;
    static int z = 0;
    test_1(int x, int y) {
        this.x = x;
        this.y = y;
    }
    static int func(int a,int b){
        return a*b + a*b*b;
    }
    public static void main(String[] args) {
        int[][] arr = new int[10][10];
        test_1 obj = new test_1(20,30);
        for(int i=0;i<10;i++){
            for(int j=0;j<10;j++){
                arr[i][j] = (i+j)*j+1;
                if(j == 8)
                    break;
            }
        }
        final int k;
        k = 10;
        k += 2;
        obj.x = obj.x*2+9;
        int x1 = func(arr[0][1],arr[1][1]);
        if(obj.x >20)
            x1 += 15;
        else
            x1 += 10;
        test_1.z = 10;
        System.out.println(x1);
        System.out.println(z);
    }

}