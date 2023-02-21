package com.xworkz.app.hospital;

import com.xworkz.app.exception.EmailNotFoundException;
import com.xworkz.app.exception.PatientNotFoundException;
import com.xworkz.app.patient.Patient;

public class Appolo implements Hospital{

boolean isFormFilled = true;
	Patient patient[];
	int i;

	public Appolo(int size) {
		patient = new Patient[size];

	}

	public Appolo() {

	}
		
	
	@Override
		public String admit(Patient patient) {
		if (patient.getPatientName() != null) {
			this.patient[i++] = patient;
		}
		return null;			
		}

	@Override
	public void getDetails() {
for(Patient p :patient) {
System.out.println(p);	
}
}

	@Override
	public Patient getPatientByID(int patientID) throws PatientNotFoundException {
		for(Patient p :patient) {

			if (p.getPatientID() == patientID) {
//				System.out.println(p.getPatientName() + "--" + p.getPatientID() + "--"
					//	+ p.getAge() + "--" + p.getBloodGroup() + "-" + p.getGender());
					System.out.println(p);
				return p;
			}else if(i>=patient.length-1) {
				
				throw new PatientNotFoundException();
			}
		}
		return null;		
	}

	@Override
	public Patient getPatientByEmail(String email) throws EmailNotFoundException {
		for(Patient p :patient) {
			if(p.getEmail().equals(email)) {
				System.out.println(p);
			}else if(i>=patient.length-1)  {
				throw new EmailNotFoundException();}
			
			
		}		return null;
	}

	@Override
	public Patient getUpdateAgebypatientId(int newage, int patientID) {
		for(Patient p :patient) {
			if (p.getPatientID()==patientID) {

				p.setAge(newage);
				//System.out.println(p.getPatientName() + "--" + pastient[i].getPatientID() + "--"
					//	+ p.getAge() + "--" + p.getBloodGroup() + "-" + p.getGender());
	System.out.println(p);
				return p;
			}

		}		return null;
	}

	@Override
	public Patient getUpadatenameBYgender(String patientNewName, String gender, String patientName) {
		for(Patient p :patient) {

			if (p.getGender().equals(gender) && p.getPatientName().equals(patientName)) {

				p.setPatientName(patientNewName);
			//	System.out.println(p.getPatientName() + "--" + p.getPatientID() + "--"
				//		+ p.getAge() + "--" + p.getBloodGroup() + "-" + p.getGender());
	System.out.println(p);
				return p;
			}		}		return null;
	}

	@Override
	public Patient getUpdategenderBypatientId(String newGender, int patientID) {
		for(Patient p :patient) {
			if (p.getPatientID()==patientID) {
				p.setGender(newGender);
			//	System.out.println(p.getPatientName() + "--" + p.getPatientID() + "--"
				//		+ p.getAge() + "--" + p.getBloodGroup() + "-" + p.getGender());
	System.out.println(p);
				return p;
			}
		}		return null;
	}

	@Override
	public Patient getUpdatebloodgroupByPatientName(String newBloodGroup, String patientName) {
		for(Patient p :patient) {
			if (p.getPatientName().equals(patientName)) {

				p.setBloodGroup(newBloodGroup);
				//System.out.println(p.getPatientName() + "--" + p.getPatientID() + "--"
					//	+ p.getAge() + "--" + p.getBloodGroup() + "-" + p.getGender());
	System.out.println(p);
				return p;
			}
			
		}		return null;
	}
	
	

}

