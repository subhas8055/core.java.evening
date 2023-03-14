package com.xworkz.airport.airports;

import com.xworkz.airport.exception.TerminalNotFoundException;
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
		for (Terminal t : terminal) {
		System.out.println(t);
	}
		
		
	}

	@Override
	public void getTerminalById(String terminalId) throws TerminalNotFoundException{
		for (Terminal t : terminal) {
			
	
			if(t.getTerminalID().equals(terminalId)) {
			System.out.println(t);
			}
			else if(i>=terminal.length-1) {
				throw new TerminalNotFoundException("No terminal found with given terminal id");
			
			}
	}
		
		
	}

	@Override
	public void updateTerminalNameById(String terminalId, String newName) {
		for (Terminal t : terminal) {
			
	
			if(t.getTerminalID().equals(terminalId)) {
				t.setTerminalName(newName);
			//System.out.println(t.getTerminalID()+"-"+t.getTerminalName()+"-"+t.getCity()+"-"+t.getNoOfTerminals());
			System.out.println(t);
		}}
	}
		
		
	}

	


