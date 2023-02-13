package com.xworkz.app;

import java.util.Scanner;

import com.xworkz.app.hospital.Appolo;
import com.xworkz.app.hospital.Hospital;
import com.xworkz.app.hospital.Manipal;
import com.xworkz.app.patient.Patient;

public class Tester {
	
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		System.out.println("please enter size");
		int size = sc.nextInt();
		Hospital hospital = new Appolo(size);
		//Hospital hospital1 = new Manipal();
		for (int i = 0; i < size; i++) {
			Patient patient = new Patient() ;
		System.out.println("please enter name ");
		patient.setPatientName(sc.next());
		System.out.println("please enter Id ");
		patient.setPatientID(sc.next());
		System.out.println("please enter bg ");
		patient.setBloodGroup(sc.next());
		System.out.println("please enter gender ");
		patient.setGender(sc.next());
		System.out.println("please enter age ");
		patient.setAge(sc.nextInt());
		 
		
	//Patient patient = new Patient( pa) ;
hospital.admit(patient);}
		
		hospital.getDetails();
		
	
	}

}
