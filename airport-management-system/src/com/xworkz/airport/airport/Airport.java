package com.xworkz.airport.airport;

import com.xworkz.airport.terminal.Terminal;

public class Airport extends Object{
	Terminal terminal[] ;
	 public int i =0;
	
	public Airport () {
		
	}
		public Airport(int size) {
			terminal = new Terminal[size];
		}
			public String trip(Terminal terminal) {
				if(terminal.getTerminalID() != null) {
					this.terminal[i++]=terminal;
					
				}
		return "abcd";	}
				public void getdisplay() {
					for(int i=0;i<terminal.length;i++) {
						System.out.println(terminal[i].getTerminalID()+"-"+terminal[i].getTerminalName()+"-"+terminal[i].getCity()+"-"+terminal[i].getNoOfTerminals());
						
					}
				}
				public void getTerminalById(String terminalId) {
					for(int i=0;i<terminal.length;i++) {
						if(terminal[i].getTerminalID().equals(terminalId)) {
						System.out.println(terminal[i].getTerminalID()+"-"+terminal[i].getTerminalName()+"-"+terminal[i].getCity()+"-"+terminal[i].getNoOfTerminals());
						
					}}
				}
				public void updateTerminalNameById(String terminalId,String newName) {
					for(int i=0;i<terminal.length;i++) {
						if(terminal[i].getTerminalID().equals(terminalId)) {
							terminal[i].setTerminalName(newName);
						System.out.println(terminal[i].getTerminalID()+"-"+terminal[i].getTerminalName()+"-"+terminal[i].getCity()+"-"+terminal[i].getNoOfTerminals());
						
					}}
				}
				
				
				
				
				
				
}
