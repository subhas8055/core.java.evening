package com.xworkz.airport;

import java.util.Scanner;

import com.xworkz.airport.airport.Airport;

import com.xworkz.airport.terminal.TerminalDTO;

public class AirportTester extends Object {
	public static void main(String[] args) {
		Scanner scanner =new Scanner (System.in);
		
		System.out.println("please enter size");
		int size = scanner.nextInt();
		Airport airport =new Airport(size);
		for(int i=0;i<size;i++) {
			System.out.println("please enter terminalId");
		int terminalId=scanner.nextInt();
		System.out.println("please enter terminal Name ");
		String terminalName =scanner.next();
		System.out.println("please enter city");
		String city = scanner.next();
		System.out.println("please enter nno of terminals");
		int nos =scanner.nextInt();	
		TerminalDTO terminal =new TerminalDTO(terminalId,terminalName,city,nos);
		airport.trip(terminal);}
		String answer ="yes";
		do {
		System.out.println("enter 1 to fetch all terminal details");
		System.out.println("enter 2 to get terminal details  by using Id ");
		System.out.println("enter 3 to update terminal name  by using Id ");
		
		int option =scanner.nextInt();
		switch(option) { 
		case 1:
		airport.getdisplay();
		break ;
		
		case 2:
			System.out.println("enter id to get terminal name"); 
			int id =scanner.nextInt();
			airport.getTerminalById(id);
			break ;
			
		case 3:
			System.out.println("enter id to update terminal name"); 
			int iD =scanner.nextInt();
			System.out.println("enter newName to update terminal name"); 
			String newName =scanner.next();
			
			airport.updateTerminalNameById(iD,newName);
			break ;
	}
		System.out.println(" thank you for dealing with us");
		System.out.println(" do you want to continue yes/no");
		
		}while(answer.equalsIgnoreCase((scanner.next())));

}}
