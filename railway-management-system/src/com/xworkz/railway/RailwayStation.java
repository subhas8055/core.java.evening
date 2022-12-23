package com.xworkz.railway;

public class RailwayStation {
	Platform platform[] =new Platform[1];
	int i;
		public RailwayStation() {
			
		}
			public String travel(Platform platform) {
				if(platform.platformID != null) {
					this.platform[i++]=platform;
				}
				
			return "asdfrewq";}
				public void getinfo() {
					for(int i=0;i<platform.length;i++) {
						System.out.println(platform[i].platformID+"-"+platform[i].city+"-"+platform[i].railwayStation+"-"+platform[i].noOfPlatform);
					}
				}
}
