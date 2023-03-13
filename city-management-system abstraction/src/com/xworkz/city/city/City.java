package com.xworkz.city.city;

import java.util.List;

import com.xworkz.city.area.AreaDTO;
import com.xworkz.city.exception.AreaNotFoundException;

public interface City {

	public AreaDTO stay(AreaDTO area);
	public List<AreaDTO> getstay();
	public List<AreaDTO> getAreaById(int areaId)throws AreaNotFoundException;
	public List<AreaDTO> getAreaByCity(String city) throws AreaNotFoundException;
	public List<AreaDTO> updatePincodeByAreaId(int areaId,int newpincode);



}
