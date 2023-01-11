package com.xworkz.managerapp;

import java.util.Scanner;

import com.xworkz.managerapp.manager.Manager;
import com.xworkz.managerapp.showroom.Showroom;

public class ShowroomTester {
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		
		System.out.println("please enter the size");
	int size = scanner.nextInt();
		Showroom showroom =new Showroom(size);
		
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
		Manager manager =new Manager(managerId,managerName,address,qualification,contactNo,gender) ;
		showroom.saveManager(manager);}
				
				showroom.getDetails();
				showroom.getManagerbyQualification("MBA");
		showroom.getManagerNameByAdress("bnglr");
			showroom.getManagerBymanagerID(1);
		showroom.getManagerByGender("female");
		System.out.println("please enter new number");
		long newNumber =scanner.nextLong();
		
		showroom.updateNumberById(newNumber, 1);
		scanner.close();
	}

}
