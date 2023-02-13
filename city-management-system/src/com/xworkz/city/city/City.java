package com.xworkz.city.city;

import com.xworkz.city.area.Area;

public class City {
	Area area[];
	int i;
	
	public City() {
		// TODO Auto-generated constructor stub
	}
		public City(int size) {
			area =new Area[size];
		}
			public Area stay(Area area) {
				if(area.getAreaId()!=null) {
					this.area[i++]=area;
					
				}return null;
			}
			public void getstay() {
				for(int i=0;i<area.length;i++) {
					//System.out.println(area[i].getAreaId()+"-"+area[i].getAreaName()+"-"+area[i].getCity()+"-"+area[i].getPincode());
			System.out.println(area[i]);
				}
			}
			public void getAreaById(String areaId) {
				for(int i=0;i<area.length;i++) {
					if(area[i].getAreaId().equals(areaId)) {
					System.out.println(area[i]);
						//System.out.println(area[i].getAreaId()+"-"+area[i].getAreaName()+"-"+area[i].getCity()+"-"+area[i].getPincode());
				}}
			}
			public void getAreaByCity(String city) {
				for(int i=0;i<area.length;i++) {
					if(area[i].getCity().equals(city)) {
						System.out.println(area[i]);

						//System.out.println(area[i].getAreaId()+"-"+area[i].getAreaName()+"-"+area[i].getCity()+"-"+area[i].getPincode());
				}}
			}
			public void updatePincodeByAreaId(String areaId,int newpincode) {
				for(int i=0;i<area.length;i++) {
					if(area[i].getAreaId().equals(areaId)) {
						area[i].setPincode(newpincode);
						System.out.println(area[i]);

						//System.out.println(area[i].getAreaId()+"-"+area[i].getAreaName()+"-"+area[i].getCity()+"-"+area[i].getPincode());
				}}
			}
			
			
			
			
}
