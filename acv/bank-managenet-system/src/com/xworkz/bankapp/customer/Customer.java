package com.xworkz.bankapp.customer;

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
	
	public void setName(String name) {
		this.name =name; }

	public String getName() {
		return name;
	}
	public void setAccountNo(long accountNo) {
		this.accountNo=accountNo;
	}
	public long getAccountNo() {
		return accountNo;
	}
	public void setAccountId(String accountId) {
	this.accountId=accountId;
	}
	public String getAccountId() {
		return accountId;
	}
	public void setContactNo(long contactNo) {
		this.contactNo=contactNo;
	}
	public long getContactNo() {
		return contactNo;
	}
}
