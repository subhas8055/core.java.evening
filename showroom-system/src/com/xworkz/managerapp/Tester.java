package com.xworkz.managerapp;

import java.util.Collections;
import java.util.List;
import java.util.Scanner;

import com.xworkz.managerapp.comparator.AddressComparator;
import com.xworkz.managerapp.comparator.GenderComparator;
import com.xworkz.managerapp.comparator.NameComparator;
import com.xworkz.managerapp.comparator.QualificationComparator;
import com.xworkz.managerapp.exception.ManagerNotfoundException;
import com.xworkz.managerapp.manager.Manager;
import com.xworkz.managerapp.manager.ManagerDTO;
import com.xworkz.managerapp.showroom.BMW;
import com.xworkz.managerapp.showroom.KTMShowroom;
import com.xworkz.managerapp.showroom.Showroom;
import com.xworkz.managerapp.showroom.Showroom1;

public class Tester {
	
	//Showroom showroom = new KTMShowroom();
	
	
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		
		System.out.println("please enter the size");
	int size = scanner.nextInt();
	Showroom1 bmw =new BMW();
		
		for(int i=0;i<size;i++) {
		System.out.println("enter the Manager Id");
		 int managerId = scanner.nextInt();
		 System.out.println("enter manager name");
		 String managerName = scanner.next();
		 System.out.println("enter manager contact No");
		 long contactNo =scanner.nextLong();
		 System.out.println("enter manager address");
		String address = scanner.next();
		System.out.println("enter manager qualification");
		String qualification = scanner.next();
		System.out.println("enter manager gender");
		String gender =scanner.next();		
		ManagerDTO manager =new ManagerDTO(managerId,managerName,address,qualification,contactNo,gender) ;
		bmw.saveManager(manager);}
		
		List<ManagerDTO> list =bmw.getDetails();
		Collections.sort(list);
		System.out.println(list);
		Collections.sort(list, new NameComparator());
		System.out.println(list);
		Collections.sort(list, new AddressComparator());
		System.out.println(list);
		Collections.sort(list, new QualificationComparator());
		System.out.println(list);
		Collections.sort(list, new GenderComparator());
		System.out.println(list);
		System.out.println("enter 1 to get details ");
		System.out.println("enter 2  to get manager qualification");
		System.out.println("enter 3 to get manager by address");
		System.out.println("enter 4 to get manager by gender");
		System.out.println("enter 5 to update manager number");
		int option = scanner.nextInt();
		switch(option) {
		case 1:				
				
			bmw.getDetails();
			break ;
		case 2:
			System.out.println("enter manager qualification to get manager");
			String qual = scanner.next();
			try {
				bmw.getManagerbyQualification(qual);
			} catch (ManagerNotfoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break ;
			
		case 3:
			System.out.println("enter manager address to get manager");
			String address = scanner.next();
			
			try {
				bmw.getManagerNameByAdress(address);
			} catch (ManagerNotfoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		break ;
		case 4:
			System.out.println("enter manager Id to get manager");
			int id = scanner.nextInt();
			try {
				bmw.getManagerBymanagerID(id);
			} catch (ManagerNotfoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break ;
		case 5:
			System.out.println("enter manager id to update manager contact number");
			int iD = scanner.nextInt();
			System.out.println("enter manager newNumber to update manager");
			long newnumber = scanner.nextLong();
		
			try {
				bmw.updateNumberById(newnumber, iD);
			} catch (ManagerNotfoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		break ;}
	
		scanner.close();
	}

	

}
