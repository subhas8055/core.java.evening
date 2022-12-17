class Bank{
	Customer customer[] = new Customer[1];
	int i;
	public Bank(){
	System.out.println("Bank ");
	}
		public String account(Customer customer){
		System.out.println("method start");
		boolean isPresent = false;
		if(customer.accountNo != 0){
			this.customer[i++]=customer; 
			isPresent =true;
			
		}
		System.out.println("method end");
		return "Please create account";
		}
			public void details(){
			System.out.println("details method start");
			for(int i=0;i<this.customer.length;i++){
			System.out.println(customer[i].customerName+"\n"+customer[i].accountNo+"\n"+customer[i].ifsc+"\n"+customer[i].location);
			}
			}
		
}