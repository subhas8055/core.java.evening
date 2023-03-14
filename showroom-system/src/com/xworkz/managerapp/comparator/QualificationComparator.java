package com.xworkz.managerapp.comparator;

import java.util.Comparator;

import com.xworkz.managerapp.manager.ManagerDTO;

public class QualificationComparator implements Comparator<ManagerDTO> {

	@Override
	public int compare(ManagerDTO o1, ManagerDTO o2) {
		// TODO Auto-generated method stub
		return o1.getQualification().compareTo(o2.getQualification());
	}

	

}
