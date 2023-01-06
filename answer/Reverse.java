class Reverse{

public static void main(String [] S){
int num =1234 ;
int rev =0; 
int rem =0;
while(num>=1){
	rem = num%10 ;
	
	rev = rev*10 + rem;
	num =num/10;

}
System.out.println("reversed number is" +rev);


}

}