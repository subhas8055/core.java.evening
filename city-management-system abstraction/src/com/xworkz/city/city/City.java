package com.xworkz.city.city;

import com.xworkz.city.area.Area;
import com.xworkz.city.exception.AreaNotFoundException;

public interface City {

	public Area stay(Area area);
	public void getstay();
	public void getAreaById(String areaId)throws AreaNotFoundException;
	public void getAreaByCity(String city) throws AreaNotFoundException;
	public void updatePincodeByAreaId(String areaId,int newpincode);



}
