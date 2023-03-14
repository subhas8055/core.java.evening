package com.xworkz.app.hospital;

import java.util.List;

import com.xworkz.app.exception.EmailNotFoundException;
import com.xworkz.app.exception.PatientNotFoundException;
import com.xworkz.app.patient.PatientDTO;

public interface Hospital {
	


	public String admit(PatientDTO patient);

	public List<PatientDTO> getDetails();

	public List<PatientDTO> getPatientByID(int patientID) throws PatientNotFoundException;
	
	public List<PatientDTO> getPatientByEmail(String email) throws EmailNotFoundException;
		
	

	public List<PatientDTO> getUpdateAgebypatientId(int newage, int patientID);

	public List<PatientDTO> getUpadatenameBYgender(String patientNewName, String gender, String patientName) ;

	public List<PatientDTO> getUpdategenderBypatientId(String newGender, int patientID);
	public List<PatientDTO> getUpdatebloodgroupByPatientName(String newBloodGroup, String patientName);
}
