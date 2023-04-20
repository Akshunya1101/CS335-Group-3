class test_13 {
	static int fib(int n,int k)
	{
		if (n <= 1)
			return n; 
        int val = fib(n-1,k) +fib(n-2,k);
		return val;
	}

	public static void main()
	{
		int n = 9;
        int k = fib(n,1);
		System.out.println(k);
	}
}