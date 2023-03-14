package com.xworkz.theatre.comparator;

import java.util.Comparator;

import com.xworkz.theatre.screen.ScreenDTO;

public class MovieNameComparator implements Comparator<ScreenDTO> {

	

	@Override
	public int compare(ScreenDTO o1, ScreenDTO o2) {
		// TODO Auto-generated method stub
		return o1.getMovieName().compareTo(o2.getMovieName());
	}

}


