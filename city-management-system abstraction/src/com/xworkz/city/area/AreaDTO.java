package com.xworkz.city.area;
import lombok.Setter;

import java.io.Serializable;

import lombok.Getter;
@Getter
@Setter
public class AreaDTO implements Serializable,Comparable<AreaDTO> {
	private int areaId;
	private String areaName;
	private String city;
	private Integer pincode;
		public AreaDTO(int areaId,String areaName,String city,Integer pincode) {
			this.areaId=areaId;
			this.areaName=areaName;
			this.city=city;
			this.pincode=pincode;
			
			}
		@Override
		public int compareTo(AreaDTO o) {
			// TODO Auto-generated method stub
			return this.getAreaId()-o.getAreaId();
		}
}
