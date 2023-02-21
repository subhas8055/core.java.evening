package com.xworkz.app.hospital;

import com.xworkz.app.exception.EmailNotFoundException;
import com.xworkz.app.exception.PatientNotFoundException;
import com.xworkz.app.patient.Patient;

public interface Hospital {
	


	public String admit(Patient patient);

	public void getDetails();

	public Patient getPatientByID(int patientID) throws PatientNotFoundException;
	
	public Patient getPatientByEmail(String email) throws EmailNotFoundException;
		
	

	public Patient getUpdateAgebypatientId(int newage, int patientID);

	public Patient getUpadatenameBYgender(String patientNewName, String gender, String patientName) ;

	public Patient getUpdategenderBypatientId(String newGender, int patientID);
	public Patient getUpdatebloodgroupByPatientName(String newBloodGroup, String patientName);
}
