package com.xworkz.railway.comparator;

import java.util.Comparator;

import com.xworkz.railway.platform.PlatformDTO;

public class StationComparator implements Comparator<PlatformDTO> {

	
	@Override
	public int compare(PlatformDTO o1, PlatformDTO o2) {
		// TODO Auto-generated method stub
		return o1.getRailwayStation().compareTo(o2.getRailwayStation());
	}

}
