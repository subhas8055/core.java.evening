package extras.program.practice;

import java.util.Scanner;

public class Prime2 {
	public static void main(String[] args) {

		Scanner s = new Scanner(System.in);
		System.out.println("enter name");
		String name = s.next();
		name=name.toLowerCase();
		char c[] = name.toCharArray();
		int z=1;
		for (int i = 0; i < c.length; i++) {
			z=1;
			for (int j =i+1; j <c.length; j++) {
				if (c[i] == c[j]) {
				z++;
					c[j]=0;
					}
				}
			for (int j = 0; j <1; j++) {
			if(c[i]!=' ' && c[i]!=0 ) {
			System.out.println(c[i] + " " + z);}
		}}
			}}


