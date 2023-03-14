package com.xworkz.bankapp.customer;
import lombok.Setter;

import java.io.Serializable;

import lombok.Getter;
@Setter
@Getter

public class CustomerDTO implements Serializable,Comparable<CustomerDTO> {
	private String name;
	private Long accountNo;
	private Long contactNo;
	private int accountId;

	
	public CustomerDTO(String name,long accountNo,long contactNo,int accountId) {
		this.name =name;
		this.accountNo=accountNo;
		this.accountId=accountId;
		this.contactNo = contactNo;	
	}
	@Override
	public int compareTo(CustomerDTO o) {
		// TODO Auto-generated method stub
		return this.getAccountId()-o.getAccountId();
	}
	
	
}
