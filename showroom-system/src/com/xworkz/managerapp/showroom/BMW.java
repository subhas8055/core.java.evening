package com.xworkz.managerapp.showroom;

import java.util.ArrayList;
import java.util.List;

import com.xworkz.managerapp.manager.ManagerDTO;

public class BMW implements Showroom1 {
List<ManagerDTO> list = new ArrayList<ManagerDTO>();
	
@Override
	public String saveManager(ManagerDTO manager) {
		System.out.println("method 1 start");
		if (manager.getManagerName() != null && !(manager.getManagerName().isEmpty()) && manager!=null) {
			list.add(manager);
		}
		return null;
	}
@Override
	public List<ManagerDTO> getDetails() {
		
		for (ManagerDTO m : list) {
			System.out.println(m);
		}
		return list;
	}
@Override
	public List<ManagerDTO> getManagerbyQualification(String qualification) {
		System.out.println("method 3 start");
		for (ManagerDTO m : list) {
			if (m.getQualification().equals(qualification)) {
				System.out.println(list);

//				System.out.println(m.getManagerID() + " " + m.getManagerName() + " "
//						+ m.getAddress() + " " + m.getContactNo() + " "
//						+ m.getQualification() + " " + m.getGender());
			}
		}

		return list;
	}
@Override
	public List<ManagerDTO> getManagerNameByAdress(String address) {
		System.out.println("method By Adress start");
		for (ManagerDTO m : list) {
			if (m.getAddress().equals(address)) {
					System.out.println(list);
//				System.out.println(m.getManagerID() + " " + m.getManagerName() + " "
//						+ m.getAddress() + " " + m.getContactNo() + " "
//						+ m.getQualification() + " " + m.getGender());
//
//			
				}

		}

		return list;
	}
@Override
	public List<ManagerDTO> getManagerBymanagerID(int managerID) {
	for (ManagerDTO m : list) {

			if (m.getManagerID() == managerID) {
				System.out.println(list);
			}
//				System.out.println("method by ID start");
//				System.out.println(m.getManagerID() + " " + m.getManagerName() + " "
//						+ m.getAddress() + " " + m.getContactNo() + " "
//						+ m.getQualification() + " " + m.getGender());
//			
			
		}
		return list;
	}
@Override
	public List<ManagerDTO> getManagerByGender(String gender) {
	for (ManagerDTO m : list) {
			if (m.getGender().equalsIgnoreCase(gender)) {
				System.out.println(list);
//				System.out.println("method by gender start");
//				System.out.println(m.getManagerID() + " " + m.getManagerName() + " "
//						+ m.getAddress() + " " + m.getContactNo() + " "
//						+ m.getQualification() + " " + m.getGender());

			}
		}
		return list;
	}
@Override
	public List<ManagerDTO> updateNumberById(long newcontactNo, int managerID) {
		System.out.println("method update by ID start");
		for (ManagerDTO m : list) {
			if (m.getManagerID() == managerID) {
				m.setContactNo(newcontactNo);
				System.out.println(list);
//				// System.out.println(m.contactNo);
//				System.out.println(m.getManagerID() + " " + m.getManagerName() + " "
//						+ m.getAddress() + " " + m.getContactNo() + " "
//						+ m.getQualification() + " " + m.getGender());

			}
		}

		return list;
	}

}
