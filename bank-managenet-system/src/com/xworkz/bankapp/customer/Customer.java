package com.xworkz.bankapp.customer;
import lombok.Setter;
import lombok.Getter;
@Setter
@Getter

public class Customer {
	private String name;
	private long accountNo;
	private long contactNo;
	private String accountId;

	public Customer() {
		
	}
	public Customer(String name,long accountNo,long contactNo,String accountId) {
		this.name =name;
		this.accountNo=accountNo;
		this.accountId=accountId;
		this.contactNo = contactNo;	
	}
	
	
}
