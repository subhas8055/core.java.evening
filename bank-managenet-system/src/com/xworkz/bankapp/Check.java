package com.xworkz.bankapp;

public class Check {
	int a=10;

	public static void main(String[] args) {
		
		Check c = new Check();
		c.nonstatic();
	}
	
	
	public void nonstatic() {
		int d =10;
		System.out.println("hi");
		Book.statci();
	}
	
}
