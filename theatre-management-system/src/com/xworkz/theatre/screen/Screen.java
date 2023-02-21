package com.xworkz.theatre.screen;
import lombok.Setter;

import lombok.Getter;
@Setter
@Getter
public class Screen {
	private String screenId;
	private String movieName;
	private String timing ;
	private Integer noOfScreens;
	
	public Screen() {
	}
	
		public Screen(String screenId,String movieName,String timing,Integer  noOfScreens) {
			this.screenId= screenId;
			this.movieName= movieName;
			this.timing= timing;
			this.noOfScreens=noOfScreens;
			
		}

		@Override
		public String toString() {
			return "Screen [screenId=" + screenId + ", movieName=" + movieName + ", timing=" + timing + ", noOfScreens="
					+ noOfScreens + "]";
		}

		
		
}



