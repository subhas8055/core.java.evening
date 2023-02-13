package com.xworkz.airport.terminal;

import lombok.Getter;
import lombok.Setter;
@Setter
@Getter
public class Terminal {
	private String terminalID;
	private String terminalName;
	private String city;
	private Integer noOfTerminals;
	
		public Terminal(String terminalID,String terminalName,String city,Integer noOfTerminals) {
			this.terminalID=terminalID;
			this.terminalName=terminalName;
			this.city=city;
			this.noOfTerminals=noOfTerminals;
		}

		@Override
		public String toString() {
			return "Terminal [terminalID=" + terminalID + ", terminalName=" + terminalName + ", city=" + city
					+ ", noOfTerminals=" + noOfTerminals + "]";
		}
	
	

}
