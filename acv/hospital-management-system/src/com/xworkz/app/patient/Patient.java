package com.xworkz.app.patient;

public class Patient {
	private String  patientName;
	private String  patientID;
	private String bloodGroup;
	private String gender;
	private int age;
	public Patient() {
		// TODO Auto-generated constructor stub
	}
		public Patient(String patientName,String patientID,String bloodGroup,int age,String gender) {
			this.patientName=patientName;
			this.patientID=patientID;
			this.bloodGroup=bloodGroup;
			this.age=age;
			this.gender=gender;
			
		}
		public void setPatientName(String patientName) {
			this.patientName=patientName;
		}
		public String getPatientName() {
			return patientName;
		}
		public void setPatientID(String patientID) {
			this.patientID=patientID;
		}
		public String getPatientID() {
			return patientID;
		}
		public void setBloodGroup(String bloodGroup) {
			this.bloodGroup=bloodGroup;
		}
		public String getBloodGroup() {
			return bloodGroup;
		}
		public void setGender(String gender) {
			this.gender=gender;
		}
		public String getGender() {
			return gender;
		}
		public void setAge(int age) {
			this.age=age;
		}
		public int getAge() {
			return age;
		}
}
