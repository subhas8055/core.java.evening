package com.xworkz.airport.airport;

import com.xworkz.airport.terminal.TerminalDTO;

public class Airport extends Object{
	TerminalDTO terminal[] ;
	 public int i =0;
	
	public Airport () {
		
	}
		public Airport(int size) {
			terminal = new TerminalDTO[size];
		}
			public String trip(TerminalDTO terminal) {
				if(terminal.getTerminalName() != null) {
					this.terminal[i++]=terminal;
					
				}
		return "abcd";	}
				public void getdisplay() {
					for(TerminalDTO t :terminal) {
						System.out.println(t);
					}
				}
				public void getTerminalById(int terminalId) {
					for (TerminalDTO t : terminal) {
						
					
						if(t.getTerminalID()==terminalId) {
						System.out.println(t);
					}}
				}
				public void updateTerminalNameById(int terminalId,String newName) {
					for (TerminalDTO t : terminal) {
						if(t.getTerminalID()==terminalId) {
							t.setTerminalName(newName);
							System.out.println(t);
					}}
				}
				
				
				
				
				
				
}
