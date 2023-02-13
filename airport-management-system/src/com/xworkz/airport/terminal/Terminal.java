package com.xworkz.airport.terminal;
import lombok.Setter;

import java.util.Objects;

import lombok.Getter;
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

		@Override
		public int hashCode() {
			
			return this.noOfTerminals;
			// return Objects.hash(city, noOfTerminals, terminalID, terminalName);
		}

		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			Terminal other = (Terminal) obj;
			return Objects.equals(city, other.city) && Objects.equals(noOfTerminals, other.noOfTerminals)
					&& Objects.equals(terminalID, other.terminalID) && Objects.equals(terminalName, other.terminalName);
		}
		
		
}programiz

