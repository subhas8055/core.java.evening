package com.xworkz.railway.railwaystation;

import com.xworkz.railway.platform.Platform;

public class RailwayStation {
	Platform platform[];
	int i;

	public RailwayStation(int size) {
		platform = new Platform[size];
	}

	public String travel(Platform platform) {
		if (platform.getPlatformID() != null) {
			this.platform[i++] = platform;
		}

		return "asdfrewq";
	}

	public void getinfo() {
		for (int i = 0; i < platform.length; i++) {
			System.out.println(platform[i].getPlatformID() + "-" + platform[i].getCity() + "-"
					+ platform[i].getRailwayStation() + "-" + platform[i].getNoOfPlatform());
		}
	}

	public void getInfoById(String platformID) {
		for (int i = 0; i < platform.length; i++) {
			if (platform[i].getPlatformID().equals(platformID)) {
				System.out.println(platform[i].getPlatformID() + "-" + platform[i].getCity() + "-"
						+ platform[i].getRailwayStation() + "-" + platform[i].getNoOfPlatform());
			}
		}
	}

	public void updateNoOfPlatformsByrailwaystation(String railwayStation, int newNoOfPlatform) {
		for (int i = 0; i < platform.length; i++) {
			if (platform[i].getRailwayStation().equals(railwayStation)) {
				platform[i].setNoOfPlatform(newNoOfPlatform);
				System.out.println(platform[i].getPlatformID() + "-" + platform[i].getCity() + "-"
						+ platform[i].getRailwayStation() + "-" + platform[i].getNoOfPlatform());
			}
		}
	}

}
