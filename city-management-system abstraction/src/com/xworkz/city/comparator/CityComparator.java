package com.xworkz.city.comparator;

import java.util.Comparator;

import com.xworkz.city.area.AreaDTO;

public class CityComparator implements Comparator<AreaDTO> {

	@Override
	public int compare(AreaDTO o1, AreaDTO o2) {
		// TODO Auto-generated method stub
		return o1.getCity().compareTo(o2.getCity());
	}

}
