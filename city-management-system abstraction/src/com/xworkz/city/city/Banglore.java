package com.xworkz.city.city;

import java.util.ArrayList;
import java.util.List;

import com.xworkz.city.area.AreaDTO;
import com.xworkz.city.exception.AreaNotFoundException;

public class Banglore implements City{
	List<AreaDTO> list = new ArrayList<AreaDTO>();
	
		@Override
			public AreaDTO stay(AreaDTO area) {
				if(area.getAreaId()!=0) {
					list.add(area);
				}return area;
			}
		@Override
		public List<AreaDTO> getstay() {
				for (AreaDTO a : list) {
					System.out.println(a);
				}
				return list;
			}
		@Override
		public List<AreaDTO> getAreaById(int areaId) throws AreaNotFoundException{
			for (AreaDTO a : list) {
				if(a.getAreaId()==areaId) {
					System.out.println(a.getAreaId()+"-"+a.getAreaName()+"-"+a.getCity()+"-"+a.getPincode());
				}
//				else {
//					throw new AreaNotFoundException("Area not find with givem Area id");
//				}
					}
			return list;
			}
		@Override
		public List<AreaDTO> getAreaByCity(String city) throws AreaNotFoundException{
			for (AreaDTO a : list) {
					if(a.getCity().equals(city)) {
						System.out.println(a);
//					System.out.println(a.getAreaId()+"-"+a.getAreaName()+"-"+a.getCity()+"-"+a.getPincode());
				}
//					else {
//					throw new AreaNotFoundException("Area not found in the given city");
//				}
					}
			return list;
			}
		@Override
		public List<AreaDTO> updatePincodeByAreaId(int areaId,int newpincode) {
			for (AreaDTO a : list) {
					if(a.getAreaId()==areaId) {
						a.setPincode(newpincode);
						System.out.println(a);
//					System.out.println(a.getAreaId()+"-"+a.getAreaName()+"-"+a.getCity()+"-"+a.getPincode());
				}}
			return list;
			}
}
