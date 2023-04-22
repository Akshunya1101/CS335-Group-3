class CatalnNumber {

	// A recursive function to find nth catalan number
    CatalnNumber(){

    }
	int catalan(int n,int k)
	{
		int res = 0;

		// Base case
		if (n <= 1) {
			return 1;
		}
		for (int i = 0; i < n; i++) {
			res += catalan(i,k) * catalan(n - i - 1,k);
		}
		return res;
	}

	// Driver Code
	public static void main(String[] args)
	{
        CatalnNumber obj = new CatalnNumber();
        int k = obj.catalan(7,1);
		System.out.println(k);
	}
}