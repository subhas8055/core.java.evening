package com.xworkz.managerapp.showroom;

import com.xworkz.managerapp.manager.Manager;

public class Showroom {
	Manager manager[] ;
	
	int i;
	public Showroom () {
		
	}
	public Showroom(int size) {
		manager =new Manager[size];
		
	
	}
		public String saveManager(Manager manager) {
			System.out.println("method 1 start");
		if(manager.managerName!= null &&!(manager.managerName.isEmpty())) {
			this.manager[i++]=manager;
			
		}
		return "qwerty";
		}
			public void getDetails() {
				System.out.println("method 2 start");
				for(int i=0;i<manager.length;i++) {
					System.out.println(manager[i].managerID+" "+manager[i].managerName+" "+manager[i].address+" "+manager[i].contactNo+" "+manager[i].qualification+" "+manager[i].gender);
				}
			}
				public Manager  getManagerbyQualification(String qualification) {
					System.out.println("method 3 start");
					for(int i=0;i<manager.length;i++) {
						if(manager[i].qualification == qualification) {
						
						System.out.println(manager[i].managerID+" "+manager[i].managerName+" "+manager[i].address+" "+manager[i].contactNo+" "+manager[i].qualification+" "+manager[i].gender);
					}
				}
				
				return null; }
				public Manager  getManagerNameByAdress(String address) {
						System.out.println("method By Adress start");
					for(int i=0;i<manager.length;i++) {
						System.out.println("method start");
						if(manager[i].address == address) {
							
							System.out.println(manager[i].managerID+" "+manager[i].managerName+" "+manager[i].address+" "+manager[i].contactNo+" "+manager[i].qualification+" "+manager[i].gender);
							
						}
						
					}
					
			return null;}
				public Manager getManagerBymanagerID(int managerID) {
					for(int i=0;i<manager.length;i++) {
					
						if(manager[i].managerID ==managerID) {
							System.out.println("method by ID start");
							System.out.println(manager[i].managerID+" "+manager[i].managerName+" "+manager[i].address+" "+manager[i].contactNo+" "+manager[i].qualification+" "+manager[i].gender);
						}
					}
				return null;}
				public String getManagerByGender(String gender) {
					for(int i=0;i<manager.length;i++) {
						if(manager[i].gender ==gender) {
							System.out.println("method by gender start");
							System.out.println(manager[i].managerID+" "+manager[i].managerName+" "+manager[i].address+" "+manager[i].contactNo+" "+manager[i].qualification+" "+manager[i].gender);
						
						}
					}
					return null;
				}
				public Manager updateNumberById(long newcontactNo,int managerID) {
					System.out.println("method update by ID start");
					for(int i=0;i<manager.length;i++) {
						if(manager[i].managerID ==managerID) {
							this.manager[i].contactNo= newcontactNo;
							System.out.println(manager[i].contactNo);
							System.out.println(manager[i].managerID+" "+manager[i].managerName+" "+manager[i].address+" "+manager[i].contactNo+" "+manager[i].qualification+" "+manager[i].gender);
							
						}
					}
					
				return null;}
				
				
				
}
				
