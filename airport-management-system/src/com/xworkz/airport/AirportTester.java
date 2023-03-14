package com.xworkz.airport;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import com.xworkz.airport.airport.Airport;

import com.xworkz.airport.terminal.TerminalDTO;

public class AirportTester extends Object {
	public static void main(String[] args) throws NumberFormatException, IOException  {
	
//BufferReader b= new BufferReader()
		BufferedReader  br =new BufferedReader(new InputStreamReader(System.in));
		System.out.println("please enter size");
		int size =Integer.parseInt(br.readLine()) ;
		Airport airport =new Airport();
		for(int i=0;i<size;i++) {
			System.out.println("please enter terminalId");
		int terminalId=Integer.parseInt(br.readLine()) ;
		System.out.println("please enter terminal Name ");
		String terminalName =br.readLine();
		System.out.println("please enter city");
		String city = br.readLine();
		System.out.println("please enter no of terminals");
		int nos =Integer.parseInt(br.readLine()) ;	
		TerminalDTO terminal =new TerminalDTO(terminalId,terminalName,city,nos);
		airport.trip(terminal);}
		String answer ="yes";
		do {
		System.out.println("enter 1 to fetch all terminal details");
		System.out.println("enter 2 to get terminal details  by using Id ");
		System.out.println("enter 3 to update terminal name  by using Id ");
		
		int option =Integer.parseInt(br.readLine()) ;
		switch(option) { 
		case 1:
		airport.getdisplay();
		break ;
		
		case 2:
			System.out.println("enter id to get terminal name"); 
			int id =Integer.parseInt(br.readLine()) ;
			airport.getTerminalById(id);
			break ;
			
		case 3:
			System.out.println("enter id to update terminal name"); 
			int iD =Integer.parseInt(br.readLine()) ;
			System.out.println("enter newName to update terminal name"); 
			String newName =br.readLine();
			
			airport.updateTerminalNameById(iD,newName);
			break ;
	}
		System.out.println(" thank you for dealing with us");
		System.out.println(" do you want to continue yes/no");
		
		}while(answer.equalsIgnoreCase((br.readLine())));

}}
