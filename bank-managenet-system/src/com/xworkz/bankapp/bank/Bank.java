package com.xworkz.bankapp.bank;

import com.xworkz.bankapp.customer.Customer;

public class Bank {
	Customer customer[];
	int i ;

	public Bank(int size) {
		customer = new Customer[size];
	}

	public Customer saveDetails(Customer customer) {
		//boolean isAdded = false;
		if(customer.getName() != null && customer.getName() != ""){
			this.customer[i++]= customer;
			//isAdded = true;
		}
		
	return null;}
	
	
	public void getDetails() {
		for(int i=0;i<customer.length;i++) {
			System.out.println(customer[i].getName() +" "+customer[i].getAccountNo() +" "+customer[i].getAccountId() +" "+customer[i].getContactNo());
		}
		
	}
	public Customer getById(String accountId) {
		for(int i=0;i<customer.length;i++) {
			
			if(customer[i].getAccountId().equals( accountId)) {
				System.out.println(customer[i].getName() +" "+customer[i].getAccountNo() +" "+customer[i].getAccountId() +" "+customer[i].getContactNo());			
			}
		}
		
	return null;}
	public Customer getByName(String name) {
		for (int i = 0; i <customer.length; i++) {
			if(customer[i].getName().equals(name)) {
				System.out.println(customer[i].getName() +" "+customer[i].getAccountNo() +" "+customer[i].getAccountId() +" "+customer[i].getContactNo());			
				return customer[i];
			}
			
		}
		return null;
	}
public Customer updateNameById(String newName,String accountId) {
	for (int i = 0; i < customer.length; i++) {
		if(customer[i].getAccountId().equals(accountId)) {
			customer[i].setName(newName);
			System.out.println(customer[i].getName() +" "+customer[i].getAccountNo() +" "+customer[i].getAccountId() +" "+customer[i].getContactNo());	
			return customer[i];
		}
	}
	
return null;}
public Customer updateNumberById(long newNumber,String accountId) {
	for (int i = 0; i < customer.length; i++) {
		if(customer[i].getAccountId().equals(accountId)) {
			customer[i].setContactNo(newNumber);
			System.out.println(customer[i].getName() +" "+customer[i].getAccountNo() +" "+customer[i].getAccountId() +" "+customer[i].getContactNo());	
			return customer[i];
		}
	}
	
return null;}
	
	
}
