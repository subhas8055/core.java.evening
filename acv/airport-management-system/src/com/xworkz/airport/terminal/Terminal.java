package com.xworkz.airport.terminal;

public class Terminal {
	private String terminalID;
	private String terminalName;
	private String city;
	private int noOfTerminals;
		public Terminal(String terminalID,String terminalName,String city,int noOfTerminals) {
			this.terminalID=terminalID;
			this.terminalName=terminalName;
			this.city=city;
			this.noOfTerminals=noOfTerminals;
		}
		public void setTerminslID(String terminalID) {
			this.terminalID = terminalID;
		}
		public String getTerminalID() {
			return terminalID;
		}
		public void setTerminalName(String terminalName) {
			this.terminalName= terminalName;
		}
		public String getTerminalName() {
			return terminalName;
		}
		public void setCity(String city) {
			this.city=city;
		}
		public String getCity() {
			return city;
		}
		public void setNoOfTerminals(int noOfTerminals) {
			this.noOfTerminals=noOfTerminals;
		}
		public int getNoOfTerminals() {
			return noOfTerminals;
		}
		
}
