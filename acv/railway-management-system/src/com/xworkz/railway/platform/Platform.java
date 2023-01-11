package com.xworkz.railway.platform;

public class Platform {
	private String platformID;
	private String railwayStation;
	private String city;
	private int noOfPlatform;
		public Platform(String platformID,String railwayStation,String city,int noOfPlatform) {
		this.platformID=platformID;
		this.railwayStation=railwayStation;
		this.city=city;
		this.noOfPlatform=noOfPlatform;
		}
		
			public void setPlatformID(String platformID) {
				this.platformID = platformID;
							}
			public String getPlatformID() {
				return platformID;
			}
			public void setRailwayStation(String railwayStation) {
				this.railwayStation = railwayStation;
							}
			public String getRailwayStation() {
				return railwayStation;
			}
			public void setCity(String city) {
				this.city = city;
							}
			public String getCity() {
				return city;
			}
			public void setNoOfPlatform(int noOfPlatform) {
				this.noOfPlatform = noOfPlatform;
							}
			public int getNoOfPlatform() {
				return noOfPlatform;
			}
			
}
