package com.xworkz.airport;

public class AirportTester {
	public static void main(String[] args) {
		//Airport airport =new Airport();
		KIA kia = new KIA();
		Terminal terminal =new Terminal("ter 1","xyz","belgaum",5);
		kia.trip(terminal);
		kia.getdisplay();
	}

}
