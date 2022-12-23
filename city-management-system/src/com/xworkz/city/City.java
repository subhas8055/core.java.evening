package com.xworkz.city;

public class City {
	Area area[]= new Area[1];
	int i;
		public City() {
			
		}
			public String stay(Area area) {
				if(area.areaId!=null) {
					this.area[i++]=area;
					
				}return "asqwzx";
			}
			public void getstay() {
				for(int i=0;i<area.length;i++) {
					System.out.println(area[i].areaId+"-"+area[i].areaName+"-"+area[i].city+"-"+area[i].pincode);
				}
			}
}
