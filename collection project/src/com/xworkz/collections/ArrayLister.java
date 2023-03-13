package com.xworkz.collections;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class ArrayLister {
	
	public static void main(String[] args) {
		List<Area> list= new ArrayList<Area>();
		list.add(new Area(1, "Rajaji nagar", "Banglore", 560100));
		list.add(new Area(2, "ASD", "Belagavi", 590123));
		list.add(new Area(3, "BSD", "Belagavi", 590123));
		list.add(new Area(4, "CSD", "Belagavi", 590123));

Collections.sort(list, new NameComparator());
for (Area area : list) {
	System.out.println(area);
}

		
		
	}

}
