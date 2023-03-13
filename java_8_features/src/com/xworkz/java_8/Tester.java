package com.xworkz.java_8;

import com.xworkz.java_8.funinterface.Addition;
import com.xworkz.java_8.funinterface.Division;
import com.xworkz.java_8.funinterface.Modulus;
import com.xworkz.java_8.funinterface.Multiply;
import com.xworkz.java_8.funinterface.Substraction;

public class Tester {
public static void main(String[] args) {
	Substraction su=(a,b)->{
		System.out.println("start of sub method");
		System.out.println(a-b);
		System.out.println("end of sub method");
	};
	su.sub(100, 69);
	
	
	Multiply m=(a,b)->
	{
		System.out.println("start of method");
		System.out.println(a*b);
		System.out.println("end of method");
	};
	m.mul(100,69);
	
	Division d=(a,b)->
	{
		System.out.println("method start");
		System.out.println(a/b);
		System.out.println("method end");
	};
	d.div(100,25);
	
	Modulus n=(a,b)->{
		System.out.println("mod start");
		System.out.println(a%b);
		System.out.println("mod end");
	};
	n.mod(100,23);
	
	Addition ad=(a,b)->
	{
		System.out.println("addition");
		System.out.println(a+b);
		System.out.println("done");
	};
	
	ad.add(100, 69);
	
}
}
