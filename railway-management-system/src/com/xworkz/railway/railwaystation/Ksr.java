package com.xworkz.railway.railwaystation;

import java.util.ArrayList;
import java.util.List;

import com.xworkz.railway.exception.PlatformNotFoundException;
import com.xworkz.railway.platform.PlatformDTO;

public class Ksr implements RailwayStation{

	List<PlatformDTO> list = new ArrayList<PlatformDTO>();
	@Override
	public String travel(PlatformDTO platform) {
		if (platform.getPlatformID() != 0) {
		}

		return null;
	}

	@Override
	public List<PlatformDTO> getinfo() {
		for (PlatformDTO p : list) {
			System.out.println(p);
		}
		return list;
		}
		
	
	@Override
	public List<PlatformDTO> getInfoById(int platformID) throws PlatformNotFoundException {
		for (PlatformDTO p : list) {
			if (p.getPlatformID()==platformID) {
				System.out.println(list);
//				System.out.println(p.getPlatformID() + "-" + p.getCity() + "-"
//						+ p.getRailwayStation() + "-" + p.getNoOfPlatform());
//			
				}else {
				throw new PlatformNotFoundException("platform not found");
			}
		}
		return list;		
	}

	@Override
	public List<PlatformDTO> updateNoOfPlatformsByrailwaystation(String railwayStation, int newNoOfPlatform) {
		for (PlatformDTO p : list) {
			if (p.getRailwayStation().equals(railwayStation)) {
				p.setNoOfPlatform(newNoOfPlatform);
				System.out.println(p.getPlatformID() + "-" + p.getCity() + "-"
						+ p.getRailwayStation() + "-" + p.getNoOfPlatform());
			}
		}
		return list;		
	}


}

