package com.xworkz.managerapp.showroom;

import com.xworkz.managerapp.manager.Manager;

public class Showroom {
	Manager manager[];

	int i;

	public Showroom() {

	}

	public Showroom(int size) {
		manager = new Manager[size];

	}

	public String saveManager(Manager manager) {
		System.out.println("method 1 start");
		if (manager.getManagerName() != null && !(manager.getManagerName().isEmpty())) {
			this.manager[i++] = manager;

		}
		return "qwerty";
	}

	public void getDetails() {
		
		for (int i = 0; i < manager.length; i++) {
		System.out.println(manager[i]);
			//	System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
				//	+ manager[i].getAddress() + " " + manager[i].getContactNo() + " " + manager[i].getQualification()
					//+ " " + manager[i].getGender());
		}
	}

	public Manager getManagerbyQualification(String qualification) {
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getQualification().equals(qualification)) {

				/*System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());*/
				System.out.println(manager[i]);
			}
		}

		return null;
	}

	public Manager getManagerNameByAdress(String address) {
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getAddress().equals(address)) {

				/*System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());*/
				System.out.println(manager[i]);
			}

		}

		return null;
	}

	public Manager getManagerBymanagerID(int managerID) {
		for (int i = 0; i < manager.length; i++) {

			if (manager[i].getManagerID() == managerID) {
				/*System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());*/
				System.out.println(manager[i]);
			}
		}
		return null;
	}

	public String getManagerByGender(String gender) {
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getGender() == gender) {
				/*System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());
*/System.out.println(manager[i]);
			}
		}
		return null;
	}

	public Manager updateNumberById(long newcontactNo, int managerID) {
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getManagerID() == managerID) {
				manager[i].setContactNo(newcontactNo);
				// System.out.println(manager[i].contactNo);
			/*	System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());*/
				System.out.println(manager[i]);

			}
		}

		return null;
	}

}
