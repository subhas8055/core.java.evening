package com.xworkz.theatre;

import java.util.Scanner;

import com.xworkz.theatre.screen.Screen;
import com.xworkz.theatre.theatres.Theatre;

public class TheatreTester {
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		System.out.println("please enter size");
		int size = scanner.nextInt();
		
		Theatre theatre =new Theatre(size);
		for(int i=0;i<size;i++) {
			System.out.println("please enter screenId");
			String screenId =scanner.next();
			System.out.println("please enter movieName");
			String movieName =scanner.next();
			System.out.println("please enter time");
			String timing = scanner.next();
			System.out.println("please enter nos");
			int nos= scanner.nextInt();
		Screen screen =new Screen(screenId,movieName,timing,nos);
		
	theatre.watch(screen);}
	
	theatre.getDetails();	
	}

}
