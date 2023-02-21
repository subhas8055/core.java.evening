package com.xworkz.city;

import java.util.Scanner;

import com.xworkz.city.area.Area;
import com.xworkz.city.city.Banglore;
import com.xworkz.city.city.City;





public class Tester {
	
	public static void main(String[] args) {
		

Scanner scanner = new Scanner(System.in);
	
	int size = scanner.nextInt();
	
	Banglore ci =new Banglore(size);
		 	
	for (int i=0;i<size;i++) {
		
		System.out.println("please enter areaID");
	String areaId= scanner.next();
	System.out.println("please enter area Name");
	String areaName = scanner.next();
	System.out.println("please enter city");
	String city = scanner.next();
	System.out.println("please enter pincode");
	int pincode = scanner.nextInt();
	
	
	Area area = new Area(areaId,areaName,city,pincode);
	ci.stay(area);}
	
	ci.getstay();}

}
