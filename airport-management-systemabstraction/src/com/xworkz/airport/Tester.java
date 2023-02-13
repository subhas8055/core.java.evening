package com.xworkz.airport;

import java.util.Scanner;

import com.xworkz.airport.airports.KIA;
import com.xworkz.airport.terminal.Terminal;

public class Tester {
public static void main(String[] args) {
	Scanner sc = new Scanner(System.in);
	System.out.println("please enter size");
	int size =sc.nextInt();
	KIA k = new KIA(size);
	for (int i = 0; i < size; i++) {
		
		System.out.println("please enter terminalId");
		String terminalId=sc.next();
		System.out.println("please enter terminal Name ");
		String terminalName =sc.next();
		System.out.println("please enter city");
		String city = sc.next();
		System.out.println("please enter nno of terminals");
		int nos =sc.nextInt();	
		Terminal terminal =new Terminal(terminalId,terminalName,city,nos);
		k.trip(terminal);	
	}
	String answer= "yes";
	do {
		System.out.println("enter 1 to fetch all terminal details");
		System.out.println("enter 2 to get terminal details  by using Id ");
		System.out.println("enter 3 to update terminal name  by using Id ");
		
		int option =sc.nextInt();
		switch(option) { 
		case 1:
		k.getdisplay();
		break ;
		
		case 2:
			System.out.println("enter id to get terminal name"); 
			String id =sc.next();
			k.getTerminalById(id);
			break ;
			
		case 3:
			System.out.println("enter id to update terminal name"); 
			String iD =sc.next();
			System.out.println("enter newName to update terminal name"); 
			String newName =sc.next();
			
			k.updateTerminalNameById(iD,newName);
			break ;
	}
		System.out.println(" thank you for dealing with us");
		System.out.println(" do you want to continue yes/no");
		
		
	}while(answer.equalsIgnoreCase(sc.next()));
	
}
}
