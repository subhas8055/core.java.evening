package com.xworkz.apps;

public class Qaz {
	public static void main(String[] args)   {
		System.out.println("main start");
		       try {
				m1();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				
			}
				
				System.out.println("main end");
			}
			
			public  static void  m1() throws ClassNotFoundException {
				System.out.println("m1 start");
				m2();
				System.out.println("m1 end");

			}

			public static void m2() throws ClassNotFoundException {
				System.out.println("m2 start");
				m3();
				System.out.println("m2 end");

				
			}
			public void display() {
				
			}

			public   static void m3() throws ClassNotFoundException {
				System.out.println("m3 start");
		    Class.forName("com.xworkz.apps.Qa");	
		     System.out.println("m3 end");
			}
}

