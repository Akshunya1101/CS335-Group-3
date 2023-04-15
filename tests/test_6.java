public class GFG {
    int x;
    double y;

    GFG(int x, double y){
        this.x = x;
        this.y = y;
    }
    double sum(int a, double b){
        double res = a + b;
        return res;
    }

    void main(int args){
        GFG obj = new GFG(1, 2.0);
        double ans = sum(5, 10.0);
        return;
    }
}