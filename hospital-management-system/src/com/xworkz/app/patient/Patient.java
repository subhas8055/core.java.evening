package com.xworkz.app.patient;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
@Setter
@Getter
@AllArgsConstructor

public class Patient {
	private String  patientName;
	private int  patientID;
	private String bloodGroup;
	private String gender;
	private Integer age;
	private String email;
	
	public Patient() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public String toString() {
		return "Patient [patientName=" + patientName + ", patientID=" + patientID + ", bloodGroup=" + bloodGroup
				+ ", gender=" + gender + ", age=" + age + ", email=" + email + "]";
	}
		
		
		
}
