public class Main{
    int x,y,z;
    int yo(){
        int x = 10;
        this.x = 30;
    }
    public static void main(){
        Main obj = new Main();
        yo();
        System.out.println(x);
    }
}