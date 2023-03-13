package com.xworkz.managerapp.showroom;

import com.xworkz.managerapp.exception.ManagerNotfoundException;
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

	public Manager getManagerbyQualification(String qualification) throws ManagerNotfoundException {
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getQualification().equals(qualification)) {

				/*System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());*/
				System.out.println(manager[i]);
			}else {
				throw new ManagerNotfoundException("Manager not found with given qualification");
			}
		}

		return null;
	}

	public Manager getManagerNameByAdress(String address) throws ManagerNotfoundException {
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getAddress().equals(address)) {

				/*System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());*/
				System.out.println(manager[i]);
			}
			else {
				throw new ManagerNotfoundException("Manager not found with given address");

			}

		}

		return null;
	}

	public Manager getManagerBymanagerID(int managerID) throws ManagerNotfoundException {
		for (int i = 0; i < manager.length; i++) {

			if (manager[i].getManagerID() == managerID) {
				/*System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());*/
				System.out.println(manager[i]);
			}else {
				throw new ManagerNotfoundException("Manager not found with given id");

			}
		}
		return null;
	}

	public String getManagerByGender(String gender) throws ManagerNotfoundException {
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getGender() == gender) {
				/*System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());
*/System.out.println(manager[i]);
			}else {
				throw new ManagerNotfoundException("Manager not found with given gender");

			}
		}
		return null;
	}

	public Manager updateNumberById(long newcontactNo, int managerID) throws ManagerNotfoundException {
		for (int i = 0; i < manager.length; i++) {
			if (manager[i].getManagerID() == managerID) {
				manager[i].setContactNo(newcontactNo);
				// System.out.println(manager[i].contactNo);
			/*	System.out.println(manager[i].getManagerID() + " " + manager[i].getManagerName() + " "
						+ manager[i].getAddress() + " " + manager[i].getContactNo() + " "
						+ manager[i].getQualification() + " " + manager[i].getGender());*/
				System.out.println(manager[i]);

			}
			else {
				throw new ManagerNotfoundException("Manager not found with given id");

			}
		}

		return null;
	}

}
