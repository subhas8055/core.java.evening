package com.xworkz.bankapp.comparator;

import java.util.Comparator;

import com.xworkz.bankapp.customer.CustomerDTO;

public class AccountNoComparator implements Comparator<CustomerDTO>{

	@Override
	public int compare(CustomerDTO o1, CustomerDTO o2) {
		// TODO Auto-generated method stub
		return o1.getAccountNo().compareTo(o2.getAccountNo());
	}

}
