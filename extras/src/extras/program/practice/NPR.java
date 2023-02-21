package extras.program.practice;

import java.util.Scanner;

public class NPR extends Practice {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);

		System.out.println("please enter n value");
		int n =sc.nextInt();
		System.out.println("please enter r value");
		int r =sc.nextInt();
		String ans="yes";
		do {
			System.out.println("enter 1 to get factorial of a number");
			System.out.println("enter 2 to get nPr value");
			System.out.println("enter 3 to get nCr value");
			int option = sc.nextInt();
			switch(option){
			case 1:
				Practice.factorial(n);
				break ;
			case 2:
				Practice.nPr(n,r);
				break ;
			case 3:
				Practice.nCr(n,r);
				break ;
				default :
					System.out.println("please enter valid option");
					break ;
			}
			System.out.println("thanks for visiting");
			System.out.println("do you want to continue yes/no");
		}while(ans.equalsIgnoreCase(sc.next()));
	}}