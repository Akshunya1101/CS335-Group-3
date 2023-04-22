//Test case to depict the use of static variables
public class Main
{
    static int x = 4;
    static int y = 6;
    static int z;
    int sum(int a, int b, int c) {
        return a + b + c;
    }
	public static void main() {
        Main.x = 9;
        Main.y = 8;
        z = sum(x, 7, Main.y);
        System.out.println(Main.x + y - Main.z);
        return ;
	}
}