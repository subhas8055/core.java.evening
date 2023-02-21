package com.xworkz.railway.railwaystation;

import com.xworkz.railway.exception.PlatformNotFoundException;
import com.xworkz.railway.platform.Platform;

public class Ksr implements RailwayStation{

	Platform platform[];
	int i;

	public Ksr(int size) {
		platform = new Platform[size];
	}

	@Override
	public String travel(Platform platform) {
		if (platform.getPlatformID() != null) {
			this.platform[i++] = platform;
		}

		return null;
	}

	@Override
	public void getinfo() {
		for (Platform p : platform) {
			System.out.println(p);
		}
		}
		
	
	@Override
	public void getInfoById(String platformID) throws PlatformNotFoundException {
		for (Platform p : platform) {
			if (p.getPlatformID().equals(platformID)) {
				System.out.println(p.getPlatformID() + "-" + p.getCity() + "-"
						+ p.getRailwayStation() + "-" + p.getNoOfPlatform());
			}else {
				throw new PlatformNotFoundException("platform not found");
			}
		}		
	}

	@Override
	public void updateNoOfPlatformsByrailwaystation(String railwayStation, int newNoOfPlatform) {
		for (Platform p : platform) {
			if (p.getRailwayStation().equals(railwayStation)) {
				p.setNoOfPlatform(newNoOfPlatform);
				System.out.println(p.getPlatformID() + "-" + p.getCity() + "-"
						+ p.getRailwayStation() + "-" + p.getNoOfPlatform());
			}
		}		
	}


}

