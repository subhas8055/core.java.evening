package com.xworkz.railway.railwaystation;

import com.xworkz.railway.platform.Platform;

public class RailwayStation {
	Platform platform[];
	int i;
		public RailwayStation(int size) {
			 platform =new Platform[size];
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
