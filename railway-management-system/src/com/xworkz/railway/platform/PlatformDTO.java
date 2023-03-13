package com.xworkz.railway.platform;
import lombok.Setter;

import java.io.Serializable;

import lombok.Getter;
@Setter
@Getter

public class PlatformDTO implements Serializable,Comparable<PlatformDTO> {
	private int platformID;
	private String railwayStation;
	private String city;
	private Integer noOfPlatform;
		public PlatformDTO(int platformID,String railwayStation,String city,Integer noOfPlatform) {
		this.platformID=platformID;
		this.railwayStation=railwayStation;
		this.city=city;
		this.noOfPlatform=noOfPlatform;
		}
		@Override
		public int compareTo(PlatformDTO o) {
			// TODO Auto-generated method stub
			return this.platformID-o.platformID;
		}
		
			
			
}
