package com.xworkz.theatre;

import java.util.Collections;
import java.util.List;
import java.util.Scanner;

import com.xworkz.theatre.comparator.MovieNameComparator;
import com.xworkz.theatre.exception.MovieNotFoundException;
import com.xworkz.theatre.screen.ScreenDTO;
import com.xworkz.theatre.theatres.Navarang;
import com.xworkz.theatre.theatres.Theatre;

public class TheatreTester {
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		System.out.println("please enter size");
		int size = scanner.nextInt();

		Navarang theatre =new Navarang();
		for(int i=0;i<size;i++) {
			System.out.println("please enter screenId");
			int screenId =scanner.nextInt();
			System.out.println("please enter movieName");
			String movieName =scanner.next();
			System.out.println("please enter time");
			String timing = scanner.next();
			System.out.println("please enter nos");
			int nos= scanner.nextInt();
			ScreenDTO screen =new ScreenDTO(screenId,movieName,timing,nos);

			theatre.watch(screen);}
		
		Collections.sort(null);
		String answer= "yes";
		do {
		System.out.println("enter 1 to sort by moviename");
		System.out.println("enter 2 to get patient details  by using Id ");
		System.out.println("enter 3 to update patient age by Id");
		System.out.println("enter 4 to sort by Id");


		int option =scanner.nextInt();
		List<ScreenDTO> list =theatre.getDetails();

		switch(option) { 
		case 1:

			Collections.sort(list, new MovieNameComparator());
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
			int  screenId = scanner.nextInt();
			System.out.println("enter new name ");
			String newName =scanner.next();
			theatre.updateMovieNameByScreenId(newName,screenId);
		
		case 4:
			Collections.sort(list);
		}
		System.out.println(" thank you for dealing with us");
		System.out.println(" do you want to continue yes/no");
	}while(answer.equalsIgnoreCase(scanner.next()));}}
