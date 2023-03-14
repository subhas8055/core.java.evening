package com.xworkz.collections;
import lombok.Setter;
import lombok.ToString;
import lombok.Getter;
@Getter
@Setter
@ToString

public class Area implements Comparable {
	
	
	
		private int areaId;
		private String areaName;
		private String city;
		private Integer pincode;
		
			public Area(int areaId,String areaName,String city,Integer pincode) {
				this.areaId=areaId;
				this.areaName=areaName;
				this.city=city;
				this.pincode=pincode;
				
				}

			@Override
			public int compareTo(Object o) {
				// TODO Auto-generated method stub
				return 0;
			}

			

			
			
	}


