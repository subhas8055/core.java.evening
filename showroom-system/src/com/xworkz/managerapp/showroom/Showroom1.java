package com.xworkz.managerapp.showroom;

import com.xworkz.managerapp.exception.ManagerNotfoundException;
import com.xworkz.managerapp.manager.Manager;

public interface Showroom1 {
	public String saveManager(Manager manager);
	public void getDetails();
	public Manager getManagerbyQualification(String qualification) throws ManagerNotfoundException ;
	public Manager getManagerNameByAdress(String address) throws ManagerNotfoundException ;
	public Manager getManagerBymanagerID(int managerID) throws ManagerNotfoundException ;
	public String getManagerByGender(String gender) throws ManagerNotfoundException ;
	public Manager updateNumberById(long newcontactNo, int managerID) throws ManagerNotfoundException ;
	
}
