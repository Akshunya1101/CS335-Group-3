//Control Flow
public class Main {
  public static void main(String[] args) {
    //Nested if-else statements
    int age=20;  
    int weight=80;
    int check = 0 ;    
    //applying condition on age and weight  
    if(age>=18){    
        if(weight<50){  
            check = 1 ;
        }
        else{
            if(!(weight <= 100)){
                check = 2 ;
            } 
            else check = 3 ;
        }    
    }
    else check = 4 ;

    System.out.println(check);

    if(check != 2) {
      check *= 5;
      System.out.println(check);
    }
  }
}
