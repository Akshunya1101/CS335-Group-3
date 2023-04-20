public class GFG {
    int x;
    int z;

    GFG(int x, int z){
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
    static int add(int a,int b){
        return a+b;
    }
    static void main(){
        GFG obj = new GFG(1, 4);
        obj.x = 2;
        int a = 20;
        int b = (24+5)*2*(5+3);
        int c = a;
        int k=obj.add(1, 12);
        System.out.println(b%(c/2));
    }
}