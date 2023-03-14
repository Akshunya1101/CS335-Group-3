public class test_4 {
    public static void main(String[] args)
	{
		int a = 20, b = 10, c = 0, d = 20, e = 40, f = 30,result;

		// precedence rules for arithmetic operators.
		// (* = / = %) > (+ = -)
		// prints a+(b/d)
		System.out.println("a+b/d = " + (a + b / d));

		// if same precedence then associative
		// rules are followed.
		// e/f -> b*d -> a+(b*d) -> a+(b*d)-(e/f)
		System.out.println("a+b*d-e/f = "
						+ (a + b * d - e / f));
        result
        = ((a > b) ? (a > c) ? a : c : (b > c) ? b : c);
        System.out.println("Max of three numbers = "
                    + result);
                    a = b++ + c;
        System.out.println("Value of a(b+c), "
                        + " b(b+1), c = " + a + ", " + b
                        + ", " + c);
	}
}
