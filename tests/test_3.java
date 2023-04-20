public class Main {
  public static void main(String[] args) {
    int time = 22;
    if (time < 10 && time > 0) {
        s = "Good morning.";
    } 
    else if (time < 18 && time != 15) {
        s = "Good day.";
    } 
    else {
        s = "Good evening.";
    }
    //Nested if-else statements
    int age=20;  
    int weight=80;
    char g = 'm' ;
    int check = 0 ;    
    //applying condition on age and weight  
    if(age>=18){    
        if(weight>50){  
            if(g == 'm'){
                check = 1 ;
            } 
            else check = 0 ;
        }
        else{
            if(g == 'm' || g == 'f'){
                check = 1 ;
            } 
            else check = 0 ;
        }    
    }
    else check = 1 ;
    for(int i=1;i<=3;i++){   
        for(int j=1;j<=3;j++){  
            if(i > j) break ; 
        } 
    }  

  }
}
