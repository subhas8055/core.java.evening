package com.xworkz.app.hospital;

import com.xworkz.app.exception.EmailNotFoundException;
import com.xworkz.app.exception.PatientNotFoundException;
import com.xworkz.app.patient.Patient;

public class Manipal implements Hospital {

public Manipal() {
	// TODO Auto-generated constructor stub
}

@Override
public String admit(Patient patient) {
	// TODO Auto-generated method stub
	return null;
}

@Override
public void getDetails() {
	// TODO Auto-generated method stub
	
}

@Override
public Patient getPatientByID(int patientID) throws PatientNotFoundException {
	// TODO Auto-generated method stub
	return null;
}

@Override
public Patient getPatientByEmail(String email) throws EmailNotFoundException {
	// TODO Auto-generated method stub
	return null;
}

@Override
public Patient getUpdateAgebypatientId(int newage, int patientID) {
	// TODO Auto-generated method stub
	return null;
}

@Override
public Patient getUpadatenameBYgender(String patientNewName, String gender, String patientName) {
	// TODO Auto-generated method stub
	return null;
}

@Override
public Patient getUpdategenderBypatientId(String newGender, int patientID) {
	// TODO Auto-generated method stub
	return null;
}

@Override
public Patient getUpdatebloodgroupByPatientName(String newBloodGroup, String patientName) {
	// TODO Auto-generated method stub
	return null;
}
}
