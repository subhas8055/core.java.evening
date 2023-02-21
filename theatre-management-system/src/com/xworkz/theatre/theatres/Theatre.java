package com.xworkz.theatre.theatres;

import com.xworkz.theatre.exception.MovieNotFoundException;
import com.xworkz.theatre.screen.Screen;

public interface Theatre {
	
		
			public String watch(Screen screen);
		public void getDetails();
		public void getTimingByMovieName(String movieName)throws MovieNotFoundException;
		public void updateMovieNameByScreenId(String newMovieName, String screenId);		
		
}
