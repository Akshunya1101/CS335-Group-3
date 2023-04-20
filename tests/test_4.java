public class test {
    int mult(int w, int k){
        if(w <= 0)
            return w+1;
        return mult(w-1, 1)+mult(w-1, 1);
    }
    //Check for String[]
	public static void main(int args) {
        int k = mult(7, 1);
        System.out.println(k);
	    return;
	}
}
