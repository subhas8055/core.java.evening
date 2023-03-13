package com.xworkz.theatre.theatres;

import com.xworkz.theatre.exception.MovieNotFoundException;
import com.xworkz.theatre.screen.Screen;

public class Navarang implements Theatre{

	Screen screen[];
	int i;
	

		public Navarang(int size) {
			screen =new Screen[size];}
		@Override

		public String watch(Screen screen) {
			if(screen.getScreenId() !=null) {
				this.screen[i++]=screen;
				
			}
			return "zxcv";
				}
		@Override

	public void getDetails() {
		for (Screen s : screen) {
			System.out.println(s);
		   							}
								}
		@Override

	public void getTimingByMovieName(String movieName)throws MovieNotFoundException {
			for (Screen s : screen) {
			if(s.getMovieName().equals(movieName)) {
		System.out.println(s);
				//	System.out.println(s.getScreenId()+"--"+s.getMovieName()+"--"+s.getTiming()+"--"+s.getNoOfScreens());
											}else {
												throw new MovieNotFoundException("No Movie found with given name");
											}
												}
								}
		@Override

	public void updateMovieNameByScreenId(String newMovieName, String screenId) {
			for (Screen s : screen) {
			if(s.getScreenId().equals(screenId)) {
				System.out.println(s);

				//System.out.println(s.getScreenId()+"--"+s.getMovieName()+"--"+s.getTiming()+"--"+s.getNoOfScreens());
											}else {
												
											}
												}
								}
	
	
}


