class BankTester{
	public static void main(String S[]){
	System.out.println("main start");
	Bank bank =new Bank();
	Customer customer = new Customer("subhas",3480898264L,"CBIN0283979","raichur");
	bank.account(customer);
	bank.details();
	System.out.println("main end");
	}
}