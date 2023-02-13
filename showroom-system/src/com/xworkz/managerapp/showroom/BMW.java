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
		for (int i = 0; i < manager.length; i++) {
			System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
					+ manager[i].getAddress() + " " + manager[i].getContactNo() + " " + manager[i].getQualification()
					+ " " + manager[i].getGender());
		}
	}
@Override
	public Manager getManagerbyQualification(String qualification) {
		System.out.println("method 3 start");
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getQualification().equals(qualification)) {

				System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());
			}
		}

		return null;
	}
@Override
	public Manager getManagerNameByAdress(String address) {
		System.out.println("method By Adress start");
		for (int i = 0; i < manager.length; i++) {
			System.out.println("method start");
			if (manager[i].getAddress().equals(address)) {

				System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());

			}

		}

		return null;
	}
@Override
	public Manager getManagerBymanagerID(int managerID) {
		for (int i = 0; i < manager.length; i++) {

			if (manager[i].getManagerID() == managerID) {
				System.out.println("method by ID start");
				System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());
			}
		}
		return null;
	}
@Override
	public String getManagerByGender(String gender) {
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getGender() == gender) {
				System.out.println("method by gender start");
				System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());

			}
		}
		return null;
	}
@Override
	public Manager updateNumberById(long newcontactNo, int managerID) {
		System.out.println("method update by ID start");
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getManagerID() == managerID) {
				manager[i].setContactNo(newcontactNo);
				// System.out.println(manager[i].contactNo);
				System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());

			}
		}

		return null;
	}

}
