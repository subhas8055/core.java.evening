package extras.program.practice;

public class Practice {

	public static int factorial(int n) {
		
		for(int i=n-1;i>=1;i--) {
			n=n*i;}
			System.out.println(n);			
		return n;
	}
	
public static int nPr(int n,int r) {
		
	int num1= Practice.factorial(n);
	int num2 =Practice.factorial(n-r);
int answer=(num1/num2);
	
	System.out.println("nPr = "+answer);
		
		return answer ;
	}
public static int nCr(int n,int r) {
	
	int num1= Practice.factorial(n);
	int num2 =Practice.factorial(n-r);
	int num3= Practice.factorial(r);
int answer=(num1/(num2*num3));
	
	System.out.println("nCr = "+answer);
		
		return answer;}
}

	



