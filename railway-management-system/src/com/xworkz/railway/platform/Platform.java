package com.xworkz.railway.platform;
import lombok.Setter;
import lombok.Getter;
@Setter
@Getter

public class Platform {
	private String platformID;
	private String railwayStation;
	private String city;
	private Integer noOfPlatform;
		public Platform(String platformID,String railwayStation,String city,Integer noOfPlatform) {
		this.platformID=platformID;
		this.railwayStation=railwayStation;
		this.city=city;
		this.noOfPlatform=noOfPlatform;
		}
		
			
			
}
