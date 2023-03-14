package com.xworkz.managerapp.comparator;

import java.util.Comparator;

import com.xworkz.managerapp.manager.ManagerDTO;

public class AddressComparator implements Comparator<ManagerDTO> {

	@Override
	public int compare(ManagerDTO o1, ManagerDTO o2) {
		// TODO Auto-generated method stub
		return o1.getAddress().compareTo(o2.getAddress());
	}

}
