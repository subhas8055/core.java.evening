package extras.program.practice;

import java.util.Scanner;

public class Leapyear {
	public static void main(String[] args) {
		
	Scanner sc = new Scanner(System.in);
	String answer ="yes";
	do {
	System.out.println("enter year");
	int year =sc.nextInt();
	
	if(year%400==0 ||year%100 ==0 ||year %4==0) {
		System.out.println("its a leap year");
		
	}
	else {
		System.out.println("not a leap year");
	}
	}while(answer.equalsIgnoreCase(sc.next()));
	}
}
