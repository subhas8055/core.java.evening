package extras.program.practice;

import java.util.Scanner;

public class Armstrong {
	public static void main(String[] args) {
	Scanner s = new Scanner(System.in);
		int a =s.nextInt();
		
		int num=a;
		int b=1;
		int n=0;
		while(a>=1){
			b=a%10;
			n=n+ b*b*b;
			a=a/10;
		}
		if(num==n) {
		System.out.println("is a armstrong number  "+num);	}
		else {System.out.println("not a armstrong number "+num );
		}}}
