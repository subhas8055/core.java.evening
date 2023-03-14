package extras.program.practice;

public class Xyz  {
	public static void main(String[] args) {
		
		Xyz f= new Xyz();
		f=null;
		System.gc();


	}

	@Override
	protected void finalize() throws Throwable {
		System.out.println(" MAJA NAHI AA RAHA HAI ,TATA BYA BYE GAYA ");
	}

}
