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
					for(Terminal t :terminal) {
						System.out.println(t);
					}
				}
				public void getTerminalById(String terminalId) {
					for (Terminal t : terminal) {
						
					
						if(t.getTerminalID().equals(terminalId)) {
						System.out.println(t);
					}}
				}
				public void updateTerminalNameById(String terminalId,String newName) {
					for (Terminal t : terminal) {
						if(t.getTerminalID().equals(terminalId)) {
							t.setTerminalName(newName);
							System.out.println(t);
					}}
				}
				
				
				
				
				
				
}
