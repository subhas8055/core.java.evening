package com.xworkz.city.city;

import com.xworkz.city.area.Area;

public interface City {

	public Area stay(Area area);
	public void getstay();
	public void getAreaById(String areaId);
	public void getAreaByCity(String city);
	public void updatePincodeByAreaId(String areaId,int newpincode);



}
