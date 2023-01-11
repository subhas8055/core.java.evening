package com.xworkz.managerapp.manager;

public class Manager {
	private int managerID;
	private String managerName;
	private String address;
	private String qualification;
	private long contactNo;
	private String gender;
		public Manager(int managerID,String managerName,String address ,String qualification,long contactNo, String gender ) {
			this.managerID=managerID;
			this.managerName=managerName;
			this.address=address;
			this.qualification=qualification;
			this.contactNo=contactNo;
			this.gender=gender;
			
		}
		public void setManagerID(int managerID) {
			this.managerID=managerID;
		}
		
		public int getManagerID() {
			return managerID;
		}
		public void setManagerName(String managerName) {
			this.managerName=managerName;
		}
			public String getManagerName() {
	return managerName;
	
}
public void setAddress(String address) {
	this.address=address;
}
public String getAddress() {
	return address;
}
public void setQualification(String qualification) {
	this.qualification =qualification;
	
}
public String getQualification() {
	return qualification;
}
public void setContactNo(long contactNo) {
	this.contactNo=contactNo;
}
public long getContactNo() {
	return contactNo;
}
public void setGender(String gender) {
	this.gender=gender;
}
public String getGender() {
	return gender;
}
} dmbang3979@centralbank.co.in





