class Add{
public static void main (String S[]){
int total= add(123,456,789);
System.out.println(total);
int total1= add(789,012,345);
System.out.println(total1);
int total2 = add(345,678,901);
System.out.println(total2);
}

public static int add(int number1,int number2,int number3){
return number1+number2+number3;
}
}
