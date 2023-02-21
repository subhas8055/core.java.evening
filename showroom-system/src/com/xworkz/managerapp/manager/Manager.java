package com.xworkz.managerapp.manager;

import lombok.Setter;
import lombok.Getter;

@Setter
@Getter

public class Manager {
	private Integer managerID;
	private String managerName;
	private String address;
	private String qualification;
	private Long contactNo;
	private String gender;

	public Manager(Integer managerID, String managerName, String address, String qualification, Long contactNo,
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
}
