package com.xworkz.apps;

import java.io.File;
import java.io.IOException;
import java.util.Scanner;

public class Asdf {
	
	public static void main(String[] args) throws ClassNotFoundException {
System.out.println("main start");
       m1();
		
		System.out.println("main end");
	}
	
	public static void  m1() throws ClassNotFoundException {
		System.out.println("m1 start");
		m2();
		System.out.println("m1 end");

	}

	public static void m2() throws ClassNotFoundException {
		System.out.println("m2 start");
		m3();
		System.out.println("m2 end");

		
	}

	public  static void m3() throws ClassNotFoundException {
		System.out.println("m3 start");
    Class.forName("com.xworkz.apps.Asdf");	
     System.out.println("m3 end");
	}
}
