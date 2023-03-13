package com.xworkz.city;

import java.util.Collections;
import java.util.List;
import java.util.Scanner;

import com.xworkz.city.area.Area;
import com.xworkz.city.area.AreaDTO;
import com.xworkz.city.city.Banglore;
import com.xworkz.city.city.City;
import com.xworkz.city.comparator.CityComparator;
import com.xworkz.city.comparator.NameComparator;
import com.xworkz.city.comparator.PincodeComparator;





public class Tester {
	
	public static void main(String[] args) {
		

Scanner scanner = new Scanner(System.in);
	
	int size = scanner.nextInt();
	
	Banglore ci =new Banglore();
		 	
	for (int i=0;i<size;i++) {
		
		System.out.println("please enter areaID");
	int areaId= scanner.nextInt();
	System.out.println("please enter area Name");
	String areaName = scanner.next();
	System.out.println("please enter city");
	String city = scanner.next();
	System.out.println("please enter pincode");
	int pincode = scanner.nextInt();
	
	
	AreaDTO area = new AreaDTO(areaId,areaName,city,pincode);
	ci.stay(area);}
	
	List<AreaDTO> list =ci.getstay();
	Collections.sort(list);
	System.out.println(list);
	Collections.sort(list, new NameComparator());
	System.out.println(list);
	Collections.sort(list, new CityComparator());
	System.out.println(list);
	Collections.sort(list, new PincodeComparator());
	System.out.println(list);
	
	}

}
