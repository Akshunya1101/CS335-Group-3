public class GFG {
    int x;
    double z;
    int[][] arr;

    GFG(int x, double z){
        this.x = x;
        this.z = z;

        if(x < z)
            return;
        else 
            this.z = x+z;
    }

    static void sub(int a, int b, float c, char d, int e, boolean f, int h,  int i){
        return;
    }

    static void main(){
        GFG obj = new GFG(1, 1.5);
        obj.x = 2;
        obj.arr =  new int[5][6];

        int a = 20;
        float b = 40;
        char c = 'a';
        boolean bool = true;

        b = b+a;
        b = a+c;
        b = a+b+c;
        bool = (b  < a) ? true: false;

        obj.add(1, 12);
        sub(1,2,3,'4', 5, true, 7, 8);
    }
}