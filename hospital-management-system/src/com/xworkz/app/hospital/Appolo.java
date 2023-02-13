package com.xworkz.app.hospital;

import com.xworkz.app.patient.Patient;

public class Appolo extends Hospital{

boolean isFormFilled = true;
		
	

	public Appolo(int size) {
		patient =new Patient[size];
		// TODO Auto-generated constructor stub
	}
	public Appolo sayHi() {
		
	return null;}
	@Override
	public String admit(Patient patient) {
		System.out.println("hi");
		if(isFormFilled == true) {
			return super.admit(patient);
		}
		
	return null;}
	

}
