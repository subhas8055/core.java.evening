package extras.program.practice;

import java.util.Scanner;

public class Extra {

	public static void main(String[] args) {
		String str1 = null;
				String str = new String("null");
				String str2 =null;
		int max,i,n;
		int a[];
		Scanner sc =new Scanner(System.in);
		System.out.println("enter n ");
		n=sc.nextInt();
		a= new int[n];
		System.out.println("enter nos");
		for(i=0;i<n;i++) {
			a[i]=sc.nextInt();				
			}
		
		max =max_num(a,n);
	System.out.println(max);
		
		}
	
	
static int max_num(int []a,int n) {
	

	for (int i = 0; i < a.length; i++) {
		for (int j = i+1; j < a.length; j++) {
			if(a[i]>a[j]) {
				int large = a[i];
				a[i]=a[j];
				a[j]=large;
			}
			
			
		}
		
	}return a[a.length-3];
}
	
	}


