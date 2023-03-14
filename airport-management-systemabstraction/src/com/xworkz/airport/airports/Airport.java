package com.xworkz.airport.airports;

import com.xworkz.airport.exception.TerminalNotFoundException;
import com.xworkz.airport.terminal.Terminal;

public interface Airport {

	
	public String trip(Terminal terminal);
	public void getdisplay();
	public void getTerminalById(String terminalId)throws TerminalNotFoundException;
	public void updateTerminalNameById(String terminalId,String newName);
}
