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
		rail.getinfo();
	}

}
