package com.xworkz.theatre.theatres;

import java.util.ArrayList;
import java.util.List;

import com.xworkz.theatre.exception.MovieNotFoundException;
import com.xworkz.theatre.screen.Screen;
import com.xworkz.theatre.screen.ScreenDTO;

public class Navarang implements Theatre{

	List<ScreenDTO> list = new ArrayList<ScreenDTO>();
	ScreenDTO sc=new ScreenDTO();
	@Override
	public String watch(ScreenDTO screen) {
		if(screen !=null && screen.getScreenId()>=1) {
			list.add(screen);

		}
		return null;
	}
	@Override

	public List<ScreenDTO> getDetails() {
		for (ScreenDTO s : list) {
			System.out.println(s);
		}
	}
	@Override

	public void getTimingByMovieName(String movieName)throws MovieNotFoundException {
		for (ScreenDTO s : list) {
			if(s.getMovieName().equals(movieName)) {
				System.out.println(s);
				//	System.out.println(s.getScreenId()+"--"+s.getMovieName()+"--"+s.getTiming()+"--"+s.getNoOfScreens());
			}else {
				throw new MovieNotFoundException("No Movie found with given name");
			}
		}
	}
	@Override

	public void updateMovieNameByScreenId(String newMovieName, int screenId) {
		for (ScreenDTO s : list) {
			if(s.getScreenId()==screenId) {
				System.out.println(s);
				s.setMovieName(newMovieName);
				//System.out.println(s.getScreenId()+"--"+s.getMovieName()+"--"+s.getTiming()+"--"+s.getNoOfScreens());
			}else {

			}
		}
	}



}


