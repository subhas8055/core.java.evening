package com.xworkz.managerapp.showroom;

import java.util.List;

import com.xworkz.managerapp.exception.ManagerNotfoundException;
import com.xworkz.managerapp.manager.ManagerDTO;

public interface Showroom1 {
	public String saveManager(ManagerDTO manager);
	public List<ManagerDTO> getDetails();
	public List<ManagerDTO> getManagerbyQualification(String qualification) throws ManagerNotfoundException ;
	public List<ManagerDTO> getManagerNameByAdress(String address) throws ManagerNotfoundException ;
	public List<ManagerDTO> getManagerBymanagerID(int managerID) throws ManagerNotfoundException ;
	public List<ManagerDTO> getManagerByGender(String gender) throws ManagerNotfoundException ;
	public List<ManagerDTO> updateNumberById(long newcontactNo, int managerID) throws ManagerNotfoundException ;
	
}
