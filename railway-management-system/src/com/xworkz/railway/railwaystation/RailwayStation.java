package com.xworkz.railway.railwaystation;

import java.util.List;

import com.xworkz.railway.exception.PlatformNotFoundException;
import com.xworkz.railway.platform.PlatformDTO;

public interface RailwayStation {
	
	public String travel(PlatformDTO platform);
	public List<PlatformDTO> getinfo() ;

	public List<PlatformDTO> getInfoById(int platformID) throws PlatformNotFoundException;

	public List<PlatformDTO> updateNoOfPlatformsByrailwaystation(String railwayStation, int newNoOfPlatform);

}
