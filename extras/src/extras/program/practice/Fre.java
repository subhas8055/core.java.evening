package extras.program.practice;

import java.util.Arrays;

public class Fre {
public static void main(String[] args) {
	String a="java";
	char  c[] =a.toCharArray();
	c[3]=c[0];
	c[0]= c[3];
	System.out.println(Arrays.toString(c));

		
	
}
}
