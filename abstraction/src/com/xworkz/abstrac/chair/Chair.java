package com.xworkz.abstrac.chair;

import com.xworkz.abstrac.plastic.Plastic;
 
public abstract class Chair implements Plastic{
	 int rent= 20;

	public String touse() {
		System.out.println(rent);
	return null;
	}
	
}
