package com.xworkz.theatre;

public class TheatreTester {
	public static void main(String[] args) {
		Theatre theatre =new Theatre();
		Screen screen =new Screen("scrn 1","KGF 2","12:30 AM",5);
		Screen screen1 =new Screen("scrn 2","kantara","12:30 AM",5);
	theatre.watch(screen);
	theatre.watch(screen1);
	theatre.getDetails();	
	}

}
