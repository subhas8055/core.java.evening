package com.xworkz.city.city;

import com.xworkz.city.area.Area;

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
					
				}return Area[i];
			}
		@Override
		public void getstay() {
				for(int i=0;i<area.length;i++) {
					System.out.println(area[i].getAreaId()+"-"+area[i].getAreaName()+"-"+area[i].getCity()+"-"+area[i].getPincode());
				}
			}
		@Override
		public void getAreaById(String areaId) {
				for(int i=0;i<area.length;i++) {
					if(area[i].getAreaId().equals(areaId)) {
					System.out.println(area[i].getAreaId()+"-"+area[i].getAreaName()+"-"+area[i].getCity()+"-"+area[i].getPincode());
				}}
			}
		@Override
		public void getAreaByCity(String city) {
				for(int i=0;i<area.length;i++) {
					if(area[i].getCity().equals(city)) {
					System.out.println(area[i].getAreaId()+"-"+area[i].getAreaName()+"-"+area[i].getCity()+"-"+area[i].getPincode());
				}}
			}
		@Override
		public void updatePincodeByAreaId(String areaId,int newpincode) {
				for(int i=0;i<area.length;i++) {
					if(area[i].getAreaId().equals(areaId)) {
						area[i].setPincode(newpincode);
					System.out.println(area[i].getAreaId()+"-"+area[i].getAreaName()+"-"+area[i].getCity()+"-"+area[i].getPincode());
				}}
			}
}
