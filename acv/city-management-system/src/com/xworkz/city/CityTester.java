package com.xworkz.city;

import java.util.Scanner;

import com.xworkz.city.area.Area;
import com.xworkz.city.city.City;

public class CityTester {
	Scanner scanner = new Scanner(System.in);
	int size = scanner.nextInt();
	City city =new City(size);
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
	city.stay(area);}
	city.getstay();}
}


