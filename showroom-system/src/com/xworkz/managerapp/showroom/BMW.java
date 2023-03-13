package com.xworkz.managerapp.showroom;

import com.xworkz.managerapp.manager.Manager;

public class BMW implements Showroom1 {

	
	Manager manager[];

	int i;

	public BMW() {

	}

	public BMW(int size) {
		manager = new Manager[size];

	}
@Override
	public String saveManager(Manager manager) {
		System.out.println("method 1 start");
		if (manager.getManagerName() != null && !(manager.getManagerName().isEmpty())) {
			this.manager[i++] = manager;

		}
		return "qwerty";
	}
@Override
	public void getDetails() {
		System.out.println("method 2 start");
		for (Manager m : manager) {
			System.out.println(m);
		}
	}
@Override
	public Manager getManagerbyQualification(String qualification) {
		System.out.println("method 3 start");
		for (Manager m : manager) {
			if (m.getQualification().equals(qualification)) {

				System.out.println(m.getManagerID() + " " + m.getManagerName() + " "
						+ m.getAddress() + " " + m.getContactNo() + " "
						+ m.getQualification() + " " + m.getGender());
			}
		}

		return null;
	}
@Override
	public Manager getManagerNameByAdress(String address) {
		System.out.println("method By Adress start");
		for (Manager m : manager) {
			System.out.println("method start");
			if (m.getAddress().equals(address)) {

				System.out.println(m.getManagerID() + " " + m.getManagerName() + " "
						+ m.getAddress() + " " + m.getContactNo() + " "
						+ m.getQualification() + " " + m.getGender());

			}

		}

		return null;
	}
@Override
	public Manager getManagerBymanagerID(int managerID) {
	for (Manager m : manager) {

			if (m.getManagerID() == managerID) {
				System.out.println("method by ID start");
				System.out.println(m.getManagerID() + " " + m.getManagerName() + " "
						+ m.getAddress() + " " + m.getContactNo() + " "
						+ m.getQualification() + " " + m.getGender());
			}
		}
		return null;
	}
@Override
	public String getManagerByGender(String gender) {
	for (Manager m : manager) {
			if (m.getGender() == gender) {
				System.out.println("method by gender start");
				System.out.println(m.getManagerID() + " " + m.getManagerName() + " "
						+ m.getAddress() + " " + m.getContactNo() + " "
						+ m.getQualification() + " " + m.getGender());

			}
		}
		return null;
	}
@Override
	public Manager updateNumberById(long newcontactNo, int managerID) {
		System.out.println("method update by ID start");
		for (Manager m : manager) {
			if (m.getManagerID() == managerID) {
				m.setContactNo(newcontactNo);
				// System.out.println(m.contactNo);
				System.out.println(m.getManagerID() + " " + m.getManagerName() + " "
						+ m.getAddress() + " " + m.getContactNo() + " "
						+ m.getQualification() + " " + m.getGender());

			}
		}

		return null;
	}

}
