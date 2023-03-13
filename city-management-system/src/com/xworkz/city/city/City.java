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
				for (Area a : area) {
					//System.out.println(a.getAreaId()+"-"+a.getAreaName()+"-"+a.getCity()+"-"+a.getPincode());
			System.out.println(a);
				}
			}
			public void getAreaById(String areaId) {
				for (Area a : area) {
					if(a.getAreaId().equals(areaId)) {
					System.out.println(a);
						//System.out.println(a.getAreaId()+"-"+a.getAreaName()+"-"+a.getCity()+"-"+a.getPincode());
				}}
			}
			public void getAreaByCity(String city) {
				for (Area a : area) {
					if(a.getCity().equals(city)) {
						System.out.println(a);

						//System.out.println(a.getAreaId()+"-"+a.getAreaName()+"-"+a.getCity()+"-"+a.getPincode());
				}}
			}
			public void updatePincodeByAreaId(String areaId,int newpincode) {
				for (Area a : area) {
					if(a.getAreaId().equals(areaId)) {
						a.setPincode(newpincode);
						System.out.println(a);

						//System.out.println(a.getAreaId()+"-"+a.getAreaName()+"-"+a.getCity()+"-"+a.getPincode());
				}}
			}
			
			
			
			
}
