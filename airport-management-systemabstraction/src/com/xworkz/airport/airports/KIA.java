package com.xworkz.airport.airports;

import com.xworkz.airport.terminal.Terminal;

public class KIA implements Airport {
	Terminal terminal[] ;
	 public int i =0;
	
	
		public KIA(int size) {
			terminal = new Terminal[size];}

	@Override
	public String trip(Terminal terminal) {
		
			if(terminal.getTerminalID() != null) {
				this.terminal[i++]=terminal;
				}
			return null;}

	@Override
	public void getdisplay() {
		for(int i=0;i<terminal.length;i++) {
		//	System.out.println(terminal[i].getTerminalID()+"-"+terminal[i].getTerminalName()+"-"+terminal[i].getCity()+"-"+terminal[i].getNoOfTerminals());
			System.out.println(terminal[i]);
	}
		
		
	}

	@Override
	public void getTerminalById(String terminalId) {
		for(int i=0;i<terminal.length;i++) {
			if(terminal[i].getTerminalID().equals(terminalId)) {
			//System.out.println(terminal[i].getTerminalID()+"-"+terminal[i].getTerminalName()+"-"+terminal[i].getCity()+"-"+terminal[i].getNoOfTerminals());
			System.out.println(terminal[i]);
			}
			else {System.out.println("please enter valid Id");
			
			}
	}
		
		
	}

	@Override
	public void updateTerminalNameById(String terminalId, String newName) {
		for(int i=0;i<terminal.length;i++) {
			if(terminal[i].getTerminalID().equals(terminalId)) {
				terminal[i].setTerminalName(newName);
			//System.out.println(terminal[i].getTerminalID()+"-"+terminal[i].getTerminalName()+"-"+terminal[i].getCity()+"-"+terminal[i].getNoOfTerminals());
			System.out.println(terminal[i]);
		}}
	}
		
		
	}

	


