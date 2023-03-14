package com.xworkz.theatre;

import java.util.Scanner;

import com.xworkz.theatre.screen.ScreenDTO;
import com.xworkz.theatre.theatres.Theatre;

public class Tester1 {
public static void main(String[] args) {
	
		Scanner sc = new Scanner(System.in);
		System.out.println("please enter ScreenID");
		String screenId = sc.next();
		System.out.println(screenId);
		System.out.println("please enter name");
		String movieName = sc.next();
		System.out.println(movieName);
		System.out.println("please enter timing");
		String timing = sc.next();
		System.out.println(timing);
		System.out.println("please enter nos");
		int  nos = sc.nextInt();
		System.out.println(nos);
		ScreenDTO screen = new ScreenDTO();
		//Theatre theatre = new Theatre();
		
		System.out.println(screen.getScreenId() +" " +screen.getMovieName() +" " +screen.getTiming() +" " +screen.getNoOfScreens());
}

}
