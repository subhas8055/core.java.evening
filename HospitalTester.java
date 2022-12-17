class HospitalTester{
	public static void main(String S[]){
			System.out.println("main start");
	Hospital hospital =new Hospital();
	Patient patient =new Patient(1 ,"gfdsa", "o+","male",29);
	hospital.admit(patient);
	hospital.display();
	System.out.println("main end");
	}
	
	}


