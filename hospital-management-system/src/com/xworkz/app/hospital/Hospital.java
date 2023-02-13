package com.xworkz.app.hospital;

import com.xworkz.app.patient.Patient;

public class Hospital {
	Patient patient[];
	int i;

	public Hospital(int size) {
		patient = new Patient[size];

	}

	public Hospital() {

	}

	public Hospital sayHi() {

		return null;
	}

	public String admit(Patient patient) {
		if (patient.getPatientName() != null) {
			this.patient[i++] = patient;
		}
		return null;
	}

	public void getDetails() {
		System.out.println("invoke");
		for (int i = 0; i < patient.length; i++) {
System.out.println(patient[i]);		}
	}

	public Patient getPatientByID(String patientID) {

		for (int i = 0; i < patient.length; i++) {

			if (patient[i].getPatientID().equals(patientID)) {
				//System.out.println(patient[i].getPatientName() + "--" + patient[i].getPatientID() + "--"
					//	+ patient[i].getAge() + "--" + patient[i].getBloodGroup() + "-" + patient[i].getGender());
System.out.println(patient[i]);
				return patient[i];
			}
		}
		return null;
	}

	public Patient getUpdateAgebypatientId(int newage, String patientID) {

		for (int i = 0; i < patient.length; i++) {
			if (patient[i].getPatientID().equals(patientID)) {

				patient[i].setAge(newage);
				//System.out.println(patient[i].getPatientName() + "--" + patient[i].getPatientID() + "--"
					//	+ patient[i].getAge() + "--" + patient[i].getBloodGroup() + "-" + patient[i].getGender());
System.out.println(patient[i]);
				return patient[i];
			}

		}
		return null;
	}

	public Patient getUpadatenameBYgender(String patientNewName, String gender, String patientName) {

		for (int i = 0; i < patient.length; i++) {

			if (patient[i].getGender().equals(gender) && patient[i].getPatientName().equals(patientName)) {

				patient[i].setPatientName(patientNewName);
			//	System.out.println(patient[i].getPatientName() + "--" + patient[i].getPatientID() + "--"
				//		+ patient[i].getAge() + "--" + patient[i].getBloodGroup() + "-" + patient[i].getGender());
System.out.println(patient[i]);
				return patient[i];
			}
		}
		return null;
	}

	public Patient getUpdategenderBypatientId(String newGender, String patientID) {
		System.out.println("gender update start5");
		for (int i = 0; i < patient.length; i++) {
			if (patient[i].getPatientID().equals(patientID)) {
				patient[i].setGender(newGender);
			//	System.out.println(patient[i].getPatientName() + "--" + patient[i].getPatientID() + "--"
				//		+ patient[i].getAge() + "--" + patient[i].getBloodGroup() + "-" + patient[i].getGender());
System.out.println(patient[i]);
				return patient[i];
			}
		}
		return null;
	}

	public Patient getUpdatebloodgroupByPatientName(String newBloodGroup, String patientName) {

		for (int i = 0; i < patient.length; i++) {
			if (patient[i].getPatientName().equals(patientName)) {

				patient[i].setBloodGroup(newBloodGroup);
				//System.out.println(patient[i].getPatientName() + "--" + patient[i].getPatientID() + "--"
					//	+ patient[i].getAge() + "--" + patient[i].getBloodGroup() + "-" + patient[i].getGender());
System.out.println(patient[i]);
				return patient[i];
			}
		}
		return null;
	}
}
