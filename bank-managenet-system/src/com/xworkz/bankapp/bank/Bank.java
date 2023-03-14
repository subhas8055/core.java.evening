package com.xworkz.bankapp.bank;

import java.util.ArrayList;
import java.util.List;

import com.xworkz.bankapp.customer.CustomerDTO;

public class Bank {
	List<CustomerDTO> list = new ArrayList<CustomerDTO>();
	public CustomerDTO saveDetails(CustomerDTO customer) {
		//boolean isAdded = false;
		if(customer.getName() != null && customer.getName() != ""){
			list.add(customer);
			//isAdded = true;
		}
		
	return customer;}
	
	
	public List<CustomerDTO> getDetails() {
		for (CustomerDTO c : list) {
			System.out.println(c);
		
			//System.out.println(c.getName() +" "+c.getAccountNo() +" "+c.getAccountId() +" "+c.getContactNo());
		}
		return list;
		
	}
	public List<CustomerDTO> getById(int accountId) {
for (CustomerDTO c : list) {			
			if(c.getAccountId()== accountId) {
				System.out.println(c);
				//System.out.println(c.getName() +" "+c.getAccountNo() +" "+c.getAccountId() +" "+c.getContactNo());			
			}
		}
		
	return list;}
	public List<CustomerDTO> getByName(String name) {
		for (CustomerDTO c : list) {
			if(c.getName().equals(name)) {
				System.out.println(c);
				//System.out.println(c.getName() +" "+c.getAccountNo() +" "+c.getAccountId() +" "+c.getContactNo());			
				return list;
			}
			
		}
		return list;
	}
public List<CustomerDTO> updateNameById(String newName,int accountId) {
for (CustomerDTO c : list) {
	if(c.getAccountId()==accountId) {
			c.setName(newName);
			System.out.println(c);
			//System.out.println(c.getName() +" "+c.getAccountNo() +" "+c.getAccountId() +" "+c.getContactNo());	
			return list;
		}
	}
	
return list;}
public List<CustomerDTO> updateNumberById(long newNumber,int accountId) {
for (CustomerDTO c : list) {
	if(c.getAccountId()==accountId) {
			c.setContactNo(newNumber);
			System.out.println(c);
			//System.out.println(c.getName() +" "+c.getAccountNo() +" "+c.getAccountId() +" "+c.getContactNo());	
			return list;
		}
	}
	
return list;}
	
	
}
