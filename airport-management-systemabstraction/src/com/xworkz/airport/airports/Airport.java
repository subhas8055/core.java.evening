package com.xworkz.airport.airports;

import com.xworkz.airport.terminal.Terminal;

public interface Airport {

	
	public String trip(Terminal terminal);
	public void getdisplay();
	public void getTerminalById(String terminalId);
	public void updateTerminalNameById(String terminalId,String newName);
}
