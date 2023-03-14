package extras.program.practice;

public class Polindrome {
public static void main(String[] args) {
	String a ="ganag";
	String s=a;
	String r ="";
	char c[] =a.toCharArray();
	for (int i=c.length-1; i>=0; i--) {
		r=r+c[i];
	}
	System.out.println(s);
	System.out.println(r);
	if(s.equals(r)) {
		System.out.println("yes buddy");
	}
	else {
		System.out.println("no buddy");
	}
}
}
