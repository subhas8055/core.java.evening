class TicketTester{
	public static void main(String S[]){
	System.out.println("main start");
		Ticket tickets = new Ticket();
		Passanger passanger = new Passanger("sangamesh","rajaji nagar","triveni hotel", 892,"8:30 pm");
		tickets.ticket(passanger);
		tickets.show();
		System.out.println("2nd object start");
		Ticket tickets1 = new Ticket();
		Passanger passanger1 = new Passanger("basan","yashwantpur","belagavi", 1000,"6:30 pm");
		tickets1.ticket(passanger1);
		tickets1.show();
		System.out.println("3 rd object start");
		Ticket tickets2 = new Ticket();
		Passanger passanger2 = new Passanger("basan","yashwantpur","belagavi", 1000,"6:30 pm");
		tickets2.ticket(passanger1);
		tickets2.show();
		System.out.println("main end");
	
	}

}