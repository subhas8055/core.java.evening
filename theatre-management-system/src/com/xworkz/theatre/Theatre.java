package com.xworkz.theatre;

public class Theatre {
	Screen screen[]=new Screen[2];
	int i;
		public Theatre() {
			
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
