public class GFG {
    int x;
    int y;

    GFG(int x, int y){
        this.x = x;
        this.y = y*2+this.x+x;
        y = 2*this.y*y;
    }
    int sum(int a, int b){
        int res = a + b;
        return res;
    }

    void main(int args){
        GFG obj = new GFG(4, 9);
        int ans = 2;
        System.out.println(obj.sum(5, 10));
        System.out.println(obj.y);
        return;
    }
}