package com.xworkz.railway;

public class RailwayTester {
	public static void main(String[] args) {
		RailwayStation rail = new RailwayStation();
		Platform platform =new Platform("PF 3","YPR","BNGLR",10);
		rail.travel(platform);
		rail.getinfo();
	}

}
