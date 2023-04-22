//Recursion: Code to find nth fibonacci number
public class MyClass {
    public static int fibonacci(int n) {
        if (n <= 1) {
            return n;
        }
        return fibonacci(n-1) + fibonacci(n-2);
    }

    public static int main() {
    int result = fibonacci(10); // calculate the 10th Fibonacci number
    System.out.println(result); // prints "55"
    return 0;
}
}