package extras.program.practice;

import java.util.Scanner;

public class Pattern {
	
	
	public static void main(String[] args) {
		strong();
		large();
		
	}
	public static void strong() {
		Scanner sc = new Scanner(System.in);
		System.out.println("enter String");
		String a=sc.next();
		System.out.println("enter string");
		String b=sc.next();
		System.out.println("enter string");
		String c=sc.next();
		if(a.equals(b)) {
			System.out.println("both are same " +a +" "+b);
		}else if(a.equals(c)) {
			System.out.println("both are same " +a +" "+c);

		}
		else if(b.equals(c)) {
			System.out.println("both are same " +b +" "+c);

		}else {
			System.out.println("no match found");
		}
	}
	
	
public static void large() {
	Scanner sc = new Scanner(System.in);
	System.out.println("enter no");
	int a=sc.nextInt();
	System.out.println("enter no");
	int b=sc.nextInt();
	System.out.println("enter no");
	int c=sc.nextInt();
if (a>b) {
	if(a>c) {
	System.out.println("greater number is  "+a);
}else {	System.out.println("greater number is  "+c);

	}}else if(b>c) {
		System.out.println("greater number is  "+b);
	}else {System.out.println("greater number is  "+c);}



}
}
