class Tester{
public static void main(String S[]){
System.out.println("main Start");
Child child =new Child();
long data=child.doBusiness();
System.out.println(data);
System.out.println("main end");
}

}