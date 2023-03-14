package extras.program.practice;

public class Reverse {
public static void main(String[] args) {
	String s = "qwerty";
	String rev="";
	char ch[]=s.toCharArray();
	System.out.println();

	System.out.println("logic 1");
	for (int i =ch.length-1; i >=0; i--) {
		System.out.print(ch[i]);
	}
	System.out.println();
	System.out.println("logic 2");
StringBuilder str = new StringBuilder();
str.append(s);
System.out.println(str.reverse());
System.out.println();


System.out.println("logic 3");
StringBuffer str1 = new StringBuffer(s);
System.out.println(str1.reverse());


System.out.println("logic 4");
for (int i =s.length()-1; i>=0; i--) {
	rev = rev+ s.charAt(i);
}
System.out.println(rev);
System.out.println(s.equalsIgnoreCase(rev));

}
}
