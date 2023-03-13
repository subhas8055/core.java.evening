package com.xworkz.bankapp.comparator;

import java.util.Comparator;

import com.xworkz.bankapp.customer.CustomerDTO;

public class ContactNoComparator implements Comparator<CustomerDTO> {

	@Override
	public int compare(CustomerDTO o1, CustomerDTO o2) {
		// TODO Auto-generated method stub
		return o1.getContactNo().compareTo(o2.getContactNo());
	}

	

}
