package com.xworkz.theatre.theatres;

import com.xworkz.theatre.screen.Screen;

public class Theatre {
	Screen screen[];
	int i;
	public Theatre() {
		
	}
		public Theatre(int size) {
			screen =new Screen[size];
		}
			public String watch(Screen screen) {
				if(screen.screenId!=null) {
					this.screen[i++]=screen;
					
				}
				return "zxcv";
					}
		public void getDetails() {
			for(int i=0;i<screen.length;i++) {
				System.out.println(screen[i].screenId+"--"+screen[i].movieName+"--"+screen[i].timing+"--"+screen[i].noOfScreens);
												}
									}

		
		
}
