package com.xworkz.app.hospital;

import java.util.ArrayList;
import java.util.List;

import com.xworkz.app.exception.EmailNotFoundException;
import com.xworkz.app.exception.PatientNotFoundException;
import com.xworkz.app.patient.PatientDTO;

public class Appolo implements Hospital{

boolean isFormFilled = true;
List<PatientDTO> list = new ArrayList<PatientDTO>();
	
	@Override
		public String admit(PatientDTO patient) {
		if (patient.getPatientName() != null) {
			list.add(patient);
		}
		return null;			
		}

	@Override
	public List<PatientDTO> getDetails() {
for(PatientDTO p :list) {
System.out.println(p);	
}
return list;
}

	@Override
	public List<PatientDTO> getPatientByID(int patientID) throws PatientNotFoundException {
		for(PatientDTO p :list) {

			if (p.getPatientID() == patientID) {
				
//				System.out.println(p.getPatientName() + "--" + p.getPatientID() + "--"
					//	+ p.getAge() + "--" + p.getBloodGroup() + "-" + p.getGender());
					System.out.println(p);
				return list;
			}
//			else if(i>=patient.length-1) {
//				
//				throw new PatientNotFoundException();
//			}
		}
		return list;		
	}

	@Override
	public List<PatientDTO> getPatientByEmail(String email) throws EmailNotFoundException {
		for(PatientDTO p :list) {
			if(p.getEmail().equals(email)) {
				System.out.println(p);
			}
//			else if(i>=patient.length-1)  {
//				throw new EmailNotFoundException();}
//			
			
		}		return list;
	}

	@Override
	public List<PatientDTO> getUpdateAgebypatientId(int newage, int patientID) {
		for(PatientDTO p :list) {
			if (p.getPatientID()==patientID) {

				p.setAge(newage);
				//System.out.println(p.getPatientName() + "--" + pastient[i].getPatientID() + "--"
					//	+ p.getAge() + "--" + p.getBloodGroup() + "-" + p.getGender());
	System.out.println(p);
				return list;
			}

		}		return list;
	}

	@Override
	public List<PatientDTO> getUpadatenameBYgender(String patientNewName, String gender, String patientName) {
		for(PatientDTO p :list) {

			if (p.getGender().equals(gender) && p.getPatientName().equals(patientName)) {

				p.setPatientName(patientNewName);
			//	System.out.println(p.getPatientName() + "--" + p.getPatientID() + "--"
				//		+ p.getAge() + "--" + p.getBloodGroup() + "-" + p.getGender());
	System.out.println(p);
				return list;
			}		}		return null;
	}

	@Override
	public List<PatientDTO> getUpdategenderBypatientId(String newGender, int patientID) {
		for(PatientDTO p :list) {
			if (p.getPatientID()==patientID) {
				p.setGender(newGender);
			//	System.out.println(p.getPatientName() + "--" + p.getPatientID() + "--"
				//		+ p.getAge() + "--" + p.getBloodGroup() + "-" + p.getGender());
	System.out.println(p);
				return list;
			}
		}		return list;
	}

	@Override
	public List<PatientDTO> getUpdatebloodgroupByPatientName(String newBloodGroup, String patientName) {
		for(PatientDTO p :list) {
			if (p.getPatientName().equals(patientName)) {

				p.setBloodGroup(newBloodGroup);
				//System.out.println(p.getPatientName() + "--" + p.getPatientID() + "--"
					//	+ p.getAge() + "--" + p.getBloodGroup() + "-" + p.getGender());
	System.out.println(p);
				return list;
			}
			
		}		return list;
	}
	
	

}

