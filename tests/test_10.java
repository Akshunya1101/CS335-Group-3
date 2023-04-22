//Code to calculate the sum of all the elements of a 2D array
public class MatrixAdditionExample{  
    int x=5,y=8,z=10;
public static void main(String args[]){  
//creating two matrices    
int a[][]=new int[3][3];   
a[0][0]=1;
a[0][1]=2;
a[0][2]=3;
a[1][0]=4;
a[1][1]=5;
a[1][2]=6;
a[2][0]=7;
a[2][1]=8;
a[2][2]=9;

int x = 0;
for(int i=0;i<3;i=i+1){
    int j = 0;
    while(j<3) {
	    x += a[i][j];
        j += 1;
    }
}
System.out.println(x);
} 
}