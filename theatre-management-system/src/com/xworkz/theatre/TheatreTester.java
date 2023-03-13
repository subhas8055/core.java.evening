package com.xworkz.theatre;

import java.util.Scanner;

import com.xworkz.theatre.exception.MovieNotFoundException;
import com.xworkz.theatre.screen.Screen;
import com.xworkz.theatre.theatres.Navarang;
import com.xworkz.theatre.theatres.Theatre;

public class TheatreTester {
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		System.out.println("please enter size");
		int size = scanner.nextInt();

		Navarang theatre =new Navarang(size);
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
		String answer= "yes";
		do {
		System.out.println("enter 1 to fetch all theatre details");
		System.out.println("enter 2 to get patient details  by using Id ");
		System.out.println("enter 3 to update patient age by Id");


		int option =scanner.nextInt();
		switch(option) { 
		case 1:

			theatre.getDetails();
			break ;

		case 2:
			System.out.println("enter movie name to get timing");
			String movieName = scanner.next();
			try {
				theatre.getTimingByMovieName(movieName);
			} catch (MovieNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break ;

		case 3:
			System.out.println("enter screen Id to update movie name");
			String  screenId = scanner.next();
			System.out.println("enter new name ");
			String newName =scanner.next();
			theatre.updateMovieNameByScreenId(newName,screenId);}
		System.out.println(" thank you for dealing with us");
		System.out.println(" do you want to continue yes/no");
	}while(answer.equalsIgnoreCase(scanner.next()));}}
