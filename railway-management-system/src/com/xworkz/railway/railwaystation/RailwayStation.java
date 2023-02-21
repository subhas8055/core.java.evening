package com.xworkz.railway.railwaystation;

import com.xworkz.railway.exception.PlatformNotFoundException;
import com.xworkz.railway.platform.Platform;

public interface RailwayStation {
	
	public String travel(Platform platform);
	public void getinfo() ;

	public void getInfoById(String platformID) throws PlatformNotFoundException;

	public void updateNoOfPlatformsByrailwaystation(String railwayStation, int newNoOfPlatform);

}
