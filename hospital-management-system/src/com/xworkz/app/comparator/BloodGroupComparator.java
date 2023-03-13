package com.xworkz.app.comparator;

import java.util.Comparator;

import com.xworkz.app.patient.PatientDTO;

public class BloodGroupComparator implements Comparator<PatientDTO> {

	@Override
	public int compare(PatientDTO o1, PatientDTO o2) {
		// TODO Auto-generated method stub
		return o1.getBloodGroup().compareTo(o2.getBloodGroup());	}

}
