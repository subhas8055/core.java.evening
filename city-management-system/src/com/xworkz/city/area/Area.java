package com.xworkz.city.area;
import lombok.Setter;
import lombok.Getter;
@Setter
@Getter

public class Area extends Object{
	private String areaId;
	private String areaName;
	private String city;
	private Integer pincode;
		public Area(String areaId,String areaName,String city,Integer pincode) {
			this.areaId=areaId;
			this.areaName=areaName;
			this.city=city;
			this.pincode=pincode;
			
			}
		
		
		public Area() {
			// TODO Auto-generated constructor stub
		}


		@Override
		public String toString() {
			return "Area [areaId=" + areaId + ", areaName=" + areaName + ", city=" + city + ", pincode=" + pincode
					+ "]";
		}
		
		
}
