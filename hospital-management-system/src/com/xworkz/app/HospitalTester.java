package com.xworkz.app;

import java.util.Scanner;

import com.xworkz.app.exception.EmailNotFoundException;
import com.xworkz.app.exception.PatientNotFoundException;
import com.xworkz.app.hospital.Appolo;
import com.xworkz.app.hospital.Hospital;
import com.xworkz.app.patient.Patient;

public class HospitalTester {

	public static void main(String[] args) {
		//String answer ="yes";

		Scanner scanner = new Scanner(System.in);
		System.out.println("please enter size");
		int size = scanner.nextInt();

		
		Appolo hospital = new Appolo(size);
		for(int i=0;i<size;i++) {
			System.out.println("please enter patientName");
			String patientName = scanner.next();
			System.out.println("please enter id");
			int patientID = scanner.nextInt();
			System.out.println("please enter bloodgroup");
			String bloodGroup=scanner.next();
			System.out.println("please enter age");
			int age =scanner.nextInt();
			System.out.println("please enter gender");
			String gender =scanner.next();
			System.out.println("please enter email");
			String email =scanner.next();

			Patient patient =new Patient(patientName,patientID,bloodGroup,gender,age,email);
			hospital.admit(patient);
		}
		int option =0;
		String answer ="yes";   // "Yes"

		do {
			System.out.println("enter 1 to fetch all patient details");
			System.out.println("enter 2 to get patient details  by using Id ");
			System.out.println("enter 3 to get patient details  by using email");
			System.out.println("enter 4 to update patient age by Id");
			System.out.println("enter 5 to update patient name by gender and old name");
			System.out.println("enter 6 to update gender by patient Id");
			System.out.println("enter 7 to update blood group by patient name");
			;

			option =scanner.nextInt();
			switch(option) { 
			case 1:
				hospital.getDetails();
				break ;
			case 2:
				try {
				System.out.println("enter id to get patient name"); 
				int id =scanner.nextInt();
				hospital.getPatientByID(id);}
				catch(PatientNotFoundException e){
					e.printStackTrace();
				}
				break ;
			case 3:
				try {
				System.out.println("enter email to get patient name"); 
				String email =scanner.next();
				hospital.getPatientByEmail(email);
				}catch(EmailNotFoundException e) {
					e.printStackTrace();
				}
				break ;

			case 4:
				System.out.println("enter id to update patient age"); 
				int iD =scanner.nextInt();
				System.out.println("enter new age to update patient age"); 
				int age =scanner.nextInt();
				hospital.getUpdateAgebypatientId(age, iD);
				break ;

			case 5:
				System.out.println("enter new name to update patient name"); 
				String newName =scanner.next();
				System.out.println("enter gender to update patient name"); 
				String gender =scanner.next();
				System.out.println("enter old name to update patient name"); 
				String oldName =scanner.next();
				hospital.getUpadatenameBYgender(newName,gender,oldName);
				break ;

			case 6:
				System.out.println("enter id to update patient gender"); 
				int ID =scanner.nextInt();
				System.out.println("enter gender to update patient gender"); 
				String gende =scanner.next();
				hospital.getUpdategenderBypatientId(gende,ID);
				break ;

			case 7:
				System.out.println("enter name to update patient blood group"); 
				String name =scanner.next();
				System.out.println("enter new blood group to update patient blood group"); 
				String bloodGroup =scanner.next();
				
					hospital.getUpdatebloodgroupByPatientName(bloodGroup,name);
				
				break ;
			}
			System.out.println(" thank you for dealing with us");
			System.out.println(" do you want to continue yes/no");
		}while(answer.equalsIgnoreCase(scanner.next()) );


	}
}
