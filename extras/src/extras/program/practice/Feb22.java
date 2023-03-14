package extras.program.practice;

public class Feb22 {
public static void main(String[] args) {
	int a[]= {12,23,34,45,56,67,78};
	System.out.println("even or odd and its square");
	for (int i = 0; i < a.length; i++) {
		if(a[i]%2==0) {
			System.out.println("the give number is even "+a[i]);
			int sum = (a[i]+2)*(a[i]+2);
			System.out.println(sum);
		}
		else {
			System.out.println("the given number is odd "+ a[i]);
			int sum =a[i]*a[i];
			System.out.println(sum);
		}
	}
System.out.println("prime number and its square");
	 
	for (int i =0; i <=a.length-1; i++) {
		int b =0;
		for (int j =1; j <=a[i]; j++) {	
		if(a[i]%j==0) {
			b++;
		}}
		if(b==2) {
			System.out.println("the given number is prime" +a[i]);
			int sum = a[i]*a[i];
			System.out.println(sum);
	}else {
		System.out.println("the given number is not prime" +a[i]);
		int sum = a[i]*a[i];
		System.out.println(sum);
	}
	
	}
	
	
}


}
