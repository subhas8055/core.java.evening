package com.xworkz.railway;

import java.util.Scanner;

import com.xworkz.railway.platform.Platform;
import com.xworkz.railway.railwaystation.RailwayStation;

public class RailwayTester {
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		System.out.println("please enter size");
		int size = scanner.nextInt();
		
		RailwayStation rail = new RailwayStation(size);

		for(int i=0;i<size;i++) {
			System.out.println("please enter platformId");
			String platformId = scanner.next();
			System.out.println("please enter station");
			String station = scanner.next();
			System.out.println("please enter city");
			String city=scanner.next();
			System.out.println("please enter noOf platform");
			int platfor =scanner.nextInt();
		Platform platform =new Platform(platformId,station,city,platfor);
		
		rail.travel(platform);}
		System.out.println("enter 1 to get all shop details");
		System.out.println("enter 2 to get shop details by Id");
		System.out.println("enter 3 to update shop name by Id");

		int option = scanner.nextInt();
		switch(option) {
		case 1:
			rail.getinfo();
			break ;

		case 2:System.out.println("enter Id to get info");
		String platformID =scanner.next();
		rail.getInfoById(platformID);
		break ;
			
		case 3:
			System.out.println("enter railwastation ");
			String station =scanner.next();
			System.out.println("enter new no of platforms");
			int news = scanner.nextInt();			
			rail.updateNoOfPlatformsByrailwaystation(station, news);
	}

}}
