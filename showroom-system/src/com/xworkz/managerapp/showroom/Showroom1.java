package com.xworkz.managerapp.showroom;

import com.xworkz.managerapp.manager.Manager;

public interface Showroom1 {
	public String saveManager(Manager manager) ;
	public void getDetails();
	public Manager getManagerbyQualification(String qualification);
	public Manager getManagerNameByAdress(String address);
	public Manager getManagerBymanagerID(int managerID);
	public String getManagerByGender(String gender);
	public Manager updateNumberById(long newcontactNo, int managerID);


}
