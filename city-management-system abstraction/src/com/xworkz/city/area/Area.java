package com.xworkz.city.area;
import lombok.Setter;

import lombok.Getter;
@Getter
@Setter
public class Area {
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
}
