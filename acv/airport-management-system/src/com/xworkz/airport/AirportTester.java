package com.xworkz.airport;

import java.util.Scanner;

public class AirportTester extends Object {
	public static void main(String[] args) {
		Scanner scanner =new Scanner (System.in);
		
		System.out.println("please enter size");
		int size = scanner.nextInt();
		Airport airport =new Airport(size);
		for(int i=0;i<size;i++) {
			System.out.println("please enter terminalId");
		String terminalId=scanner.next();
		System.out.println("please enter terminal Name ");
		String terminalName =scanner.next();
		System.out.println("please enter city");
		String city = scanner.next();
		System.out.println("please enter nno of terminals");
		int nos =scanner.nextInt();	
		Terminal terminal =new Terminal(terminalId,terminalName,city,nos);
		airport.trip(terminal);}
		airport.getdisplay();
	}

}
