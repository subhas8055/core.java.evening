package com.xworkz.distribution.comparator;

import java.util.Comparator;

import com.xworkz.distribution.distributor.dto.SalesPersonDTO;

public class LocationComparator implements Comparator<SalesPersonDTO> {

	@Override
	public int compare(SalesPersonDTO o1, SalesPersonDTO o2) {
		// TODO Auto-generated method stub
		return o1.getLocation().compareTo(o2.getLocation());
	}

}
