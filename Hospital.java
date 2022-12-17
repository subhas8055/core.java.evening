class Hospital{
	Patient patient[] = new Patient[1];
	int index ;
		public Hospital(){
		System.out.println("hospital object is created");
		}
			public boolean admit(Patient patient){
			System.out.println("admit process started");
			boolean isAdmitted =false;
			if(patient.patientName!= null){
				this.patient[index++]=patient;
				isAdmitted = true;
			}
			else{
				System.out.println("please add patient name");
			}
			System.out.println("Admit process ended");
			return isAdmitted;
			}
				
				public void display(){
						System.out.println("details");
		           for(int i=0;i<this.patient.length;i++){
			
					System.out.println(patient[i].patientID+ "\n"+patient[i].patientName+ "\n"+patient[i].bloodGroup+ "\n"+patient[i].gender+ "\n"+patient[i].age);
		}
				}

}