//Arithematic Operations and Bitwise Operations
public class ArithmeticOperations {
    public static void main(String[] args) {
        int a = 13;
        int b = 5;

        int sum = a + b;
        System.out.println(sum);

        int difference = a - b;
        System.out.println(difference);

        int product = a * b;
        System.out.println(product);

        int quotient = a / b;
        System.out.println(quotient);

        int remainder = a % b;
        System.out.println(remainder);

        int c1 = 1;
        System.out.println(c1++);
        System.out.println(c1);
        int c2 = 11;
        System.out.println(++c2);
        System.out.println(c2);

        int d1 = 5;
        System.out.println(d1--);
        System.out.println(d1);
        int d2 = 15;
        System.out.println(--d2);
        System.out.println(d2);

        int e = 3;
        int f = +e;
        System.out.println(f);

        int g = 4;
        int h = -g;
        System.out.println(h);


        //Bitwise Operations
        a = 170;
        b = 85;
        int andResult = a & b;
        System.out.println(andResult);

        int orResult = a | b;
        System.out.println(orResult);

        int xorResult = a ^ b;
        System.out.println(xorResult);

        int notResult = ~a;
        System.out.println(notResult);

        int leftShiftResult = a << 2;
        System.out.println(leftShiftResult);

        int rightShiftResult = a >> 2;
        System.out.println(rightShiftResult);

        int zeroRightShiftResult = a >>> 2;
        System.out.println(zeroRightShiftResult);

    }
}
