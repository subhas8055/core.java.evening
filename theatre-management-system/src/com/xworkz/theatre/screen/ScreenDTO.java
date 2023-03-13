package com.xworkz.theatre.screen;
import lombok.Setter;

import java.io.Serializable;

import lombok.Getter;
@Setter
@Getter
public class ScreenDTO implements Serializable,Comparable<ScreenDTO> {
	private int screenId;
	private String movieName;
	private String timing ;
	private Integer noOfScreens;
	
	public ScreenDTO() {
	}
	
		public ScreenDTO(int screenId,String movieName,String timing,Integer  noOfScreens) {
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

		@Override
		public int compareTo(ScreenDTO o) {
			// TODO Auto-generated method stub
			return this.getScreenId()-o.getScreenId();
		}

		
		
}



