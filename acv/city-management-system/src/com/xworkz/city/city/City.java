package com.xworkz.city.city;

import com.xworkz.city.area.Area;

public class City extends Object{
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
					System.out.println(area[i].getAreaId()+"-"+area[i].getAreaName()+"-"+area[i].getCity()+"-"+area[i].getPincode());
				}
			}
}
