package com.xworkz.managerapp.manager;

import lombok.Setter;

import java.io.Serializable;

import lombok.Getter;

@Setter
@Getter

public class ManagerDTO implements Serializable , Comparable<ManagerDTO>{
	private Integer managerID;
	private String managerName;
	private String address;
	private String qualification;
	private Long contactNo;
	private String gender;

	public ManagerDTO(Integer managerID, String managerName, String address, String qualification, Long contactNo,
			String gender) {
		this.managerID = managerID;
		this.managerName = managerName;
		this.address = address;
		this.qualification = qualification;
		this.contactNo = contactNo;
		this.gender = gender;

	}

	@Override
	public String toString() {
		return "Manager [managerID=" + managerID + ", managerName=" + managerName + ", address=" + address
				+ ", qualification=" + qualification + ", contactNo=" + contactNo + ", gender=" + gender + "]";
	}

	

	@Override
	public int compareTo(ManagerDTO o) {
		// TODO Auto-generated method stub
		return this.getManagerID()-o.getManagerID();
	}
}
