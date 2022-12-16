class FinolexTester{
public static void main(String S[]){
System.out.println("main Start");
Finolex finolex = new Finolex();
String data =finolex.connect();
System.out.println(data);
System.out.println("main end");
}
}