package com.xworkz.apps;

public class Tester {

	public static void main(String[] args) {
		System.out.println("main start ");
		
		
		
		Bar bar = new Bar(1, "asd", "bnglr", "kiran");
		Bar bar1 = new Bar(2, "bjp", "bnglr", "vishal");
	Stall stall1 = new Stall(1,"asd", "bnglr", "karan");
	System.out.println(bar);
	System.out.println(bar1);
	//System.out.println(bar.equals(stall1));
	bar.add(1, 0);bar.toString();
	
	System.out.println("main end");
	
	}

}
