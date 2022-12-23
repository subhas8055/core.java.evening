package com.xworkz.app;

public class HospitalTester {
public static void main(String[] args) {
	System.out.println("main Start");
	Hospital hospital = new Hospital();
	Patient patient =new Patient("dileep","opd 123","A+",29);
	Patient patient1 =new Patient("kalip","opd 124","A-",32);
	hospital.admit(patient);
	hospital.admit(patient1);
	hospital.getDetails();
	System.out.println("by id main start");
	hospital.getPatientByID("opd 123");
	
	
}
}
