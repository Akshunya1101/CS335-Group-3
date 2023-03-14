public class test_5 {
    public static void main1(String args[]) {
        int age = 55;
        if (age >= 60) {
            System.out.println("Person is double-vaccinated");
        } else if (age >= 50 && age < 60) {
            System.out.println("Person is vaccinated with single-dose only");
        } else if (age >= 40 && age < 50) {
            System.out.println("Person is not vaccinated");
        } else {
            System.out.println("Person is not eligible for vaccine ");
        }
    }

    public static void main2(String args[]) {
        int age = 20, weight = 50;
        if(age >= 18) {
            System.out.println("Person is allowed to vote");
          if(weight >= 45) {
                System.out.println("Person is allowed to vote and is fit to donate blood");
          }
              else {
             System.out.println("Person is not fit to donate blood");
          }
        }   
        else {
            System.out.println("Person is not allowed to vote");
        }  
        for (;;) {
		}  
    }

    public static void main(String[] args)
	{

		int row = 1, column = 1;
		int x;
		do {
			x = 4;
			do {
				System.out.print("");
				x--;
			} while (x >= row);
			column = 1;
			do {
				System.out.print(column + " ");
				column++;

			} while (column <= 5);
			System.out.println(" ");
			row++;
		} while (row <= 5);
	}
}
