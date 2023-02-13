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
		String answer ="yes";
		do {
		System.out.println("enter 1 to get details ");
		System.out.println("enter 2  to get manager qualification");
		System.out.println("enter 3 to get manager by address");
		System.out.println("enter 4 to get manager by gender");
		System.out.println("enter 5 to update manager number");
		int option = scanner.nextInt();
		
		switch(option) {
		case 1:				
				
			showroom.getDetails();
			break ;
		case 2:
			System.out.println("enter manager qualification to get manager");
			String qual = scanner.next();
			showroom.getManagerbyQualification(qual);
			break ;
			
		case 3:
			System.out.println("enter manager address to get manager");
			String address = scanner.next();
			
		showroom.getManagerNameByAdress(address);
		break ;
		case 4:
			System.out.println("enter manager Id to get manager");
			int id = scanner.nextInt();
			showroom.getManagerBymanagerID(id);
			break ;
		case 5:
			System.out.println("enter manager id to update manager contact number");
			int iD = scanner.nextInt();
			System.out.println("enter manager newNumber to update manager");
			long newnumber = scanner.nextLong();
		
		showroom.updateNumberById(newnumber, iD);
		break ;}
		System.out.println();
		System.out.println("thanks for visiting ");
		System.out.println("do you want to continue enter yes/ no");
		}while(answer.equalsIgnoreCase(scanner.next()));
		scanner.close();
	}

}
