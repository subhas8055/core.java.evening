package com.xworkz.collections;

import java.util.Comparator;

public class NameComparator implements Comparator<Area>{

	@Override
	public int compare(Area o1, Area o2) {
		// TODO Auto-generated method stub
		return o1.getAreaName().compareTo(o2.getAreaName());
	}

}
