package com.xworkz.app.patient;
import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
@Setter
@Getter
@AllArgsConstructor


public class PatientDTO implements Serializable,Comparable<PatientDTO> {
	private String  patientName;
	private int  patientID;
	private String bloodGroup;
	private String gender;
	private Integer age;
	private String email;
	
	public PatientDTO() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public String toString() {
		return "Patient [patientName=" + patientName + ", patientID=" + patientID + ", bloodGroup=" + bloodGroup
				+ ", gender=" + gender + ", age=" + age + ", email=" + email + "]";
	}

	@Override
	public int compareTo(PatientDTO o) {
		return this.getPatientID()-o.getPatientID();
	}
		
		
		
}
