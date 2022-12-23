package com.xworkz.app;

public class Hospital {
	Patient patient[]=new Patient[2];
	int i;
		public Hospital() {
			
		}
			public String admit(Patient patient) {
				if(patient.patientName != null) {
					this.patient[i++]=patient;
				}
				return "asdfgh";
				}
			public void getDetails() {
				for(int i=0;i<patient.length;i++) {
					System.out.println(patient[i].patientName+"--"+patient[i].patientID+"--"+patient[i].age+"--"+patient[i].bloodGroup);
				}
			}
			public Patient getPatientByID(String patientID) {
				System.out.println("by id method start");
				for (int i=0;i<patient.length;i++) {
					if(patient[i].patientID == patientID) {
						System.out.println(patient[i].patientName+"--"+patient[i].patientID+"--"+patient[i].age+"--"+patient[i].bloodGroup);
						System.out.println("by id method end");
						return patient[i];
					}
				}
			return null;}
}
