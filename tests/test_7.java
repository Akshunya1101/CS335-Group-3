public class MyClass {
    public float x;
    public float y;

    public MyClass(float x, float y) {
        this.x = x;
        this.y = y;
    }
    public static int addMyClass() {
    MyClass obj = new MyClass(10, 2.5f);
    float sum = obj.x + (int)obj.y;
    float z = 1 ;
    int w = (int)z + (int)obj.y + 1 ;
    return sum;
}
}