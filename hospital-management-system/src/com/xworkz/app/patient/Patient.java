package com.xworkz.app.patient;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
@Setter
@Getter
@AllArgsConstructor

public class Patient {
	private String  patientName;
	private String  patientID;
	private String bloodGroup;
	private String gender;
	private Integer age;
	
	public Patient() {
		// TODO Auto-generated constructor stub
	}
		
		@Override
		public String toString() {
			
			return "Patient (Patient id ="+this.getPatientID()+  ",PatientName = "+this.patientName+  ",Patient Blood group = "  +this.bloodGroup+  ",Patient age = "+this.age+  ",Patient gender = "+this.gender+" )";
		}
		
}
