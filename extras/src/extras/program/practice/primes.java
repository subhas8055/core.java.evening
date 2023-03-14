package extras.program.practice;

public class primes {

	public static void main(String[] args) {
		int a[]= {23,45,12,56,67,89,10};
		

	for (int i = 0; i < a.length; i++) {
		int count =0;
		for (int j = 1; j <=a[i]; j++) {
		if(a[i] %j == 0) {
			 
			count++;
		
		}}
		if(count>2) {
			System.out.println(a[i]  +" not a prime");
		}else {
			System.out.println(a[i]  +" yes a prime");
		}
		
	}	 
	}
}
