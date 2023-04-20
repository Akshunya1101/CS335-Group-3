public class Example1 {
    public class MyClass {
         int x;
         int y;
      }

      int addMyClass(MyClass obj) {
         int sum = obj.x + obj.y;
         return sum;
      }

   public static void main(String[] args) {
         MyClass obj1 = new MyClass() ;
   		int z = addMyClass(obj1) ;
        System.out.println(z);
   }
}