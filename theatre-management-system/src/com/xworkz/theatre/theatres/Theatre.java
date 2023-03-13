package com.xworkz.theatre.theatres;

import java.util.List;

import com.xworkz.theatre.exception.MovieNotFoundException;
import com.xworkz.theatre.screen.ScreenDTO;

public interface Theatre {
			public String watch(ScreenDTO screen);
		public List<ScreenDTO> getDetails();
		public void getTimingByMovieName(String movieName)throws MovieNotFoundException;
		public void updateMovieNameByScreenId(String newMovieName, int screenId);			
}
