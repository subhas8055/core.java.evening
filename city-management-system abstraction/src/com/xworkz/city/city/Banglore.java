package com.xworkz.city.city;

import com.xworkz.city.area.Area;
import com.xworkz.city.exception.AreaNotFoundException;

public class Banglore implements City{
	Area area[];
	int i;
	
	
		public Banglore(int size) {
			area =new Area[size];
		}
		@Override
			public Area stay(Area area) {
				if(area.getAreaId()!=null) {
					this.area[i++]=area;
				}return null;
			}
		@Override
		public void getstay() {
				for (Area a : area) {
					System.out.println(a);
				}
			}
		@Override
		public void getAreaById(String areaId) throws AreaNotFoundException{
			for (Area a : area) {
				if(a.getAreaId().equals(areaId)) {
					System.out.println(a.getAreaId()+"-"+a.getAreaName()+"-"+a.getCity()+"-"+a.getPincode());
				}else {
					throw new AreaNotFoundException("Area not find with givem Area id");
				}
					}
			}
		@Override
		public void getAreaByCity(String city) throws AreaNotFoundException{
			for (Area a : area) {
					if(a.getCity().equals(city)) {
					System.out.println(a.getAreaId()+"-"+a.getAreaName()+"-"+a.getCity()+"-"+a.getPincode());
				}else {
					throw new AreaNotFoundException("Area not found in the given city");
				}
					}
			}
		@Override
		public void updatePincodeByAreaId(String areaId,int newpincode) {
			for (Area a : area) {
					if(a.getAreaId().equals(areaId)) {
						a.setPincode(newpincode);
					System.out.println(a.getAreaId()+"-"+a.getAreaName()+"-"+a.getCity()+"-"+a.getPincode());
				}}
			}
}
