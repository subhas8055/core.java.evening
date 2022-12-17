class Ticket{
 Passanger passanger []=new Passanger[2];
 int i;
		public String ticket(Passanger passanger){
		System.out.println("passanger method start");
		boolean isHadID =false;
		if(passanger.psngrName != null){
			this.passanger[i++]=passanger;
		isHadID =true;
		}
		System.out.println("passanger method  end");
		return "he had";
		}
			public void show(){
			System.out.println("show method start");
			for(int i=0;i<this.passanger.length;i++){
			System.out.println(passanger[i].psngrName+"\n"+passanger[i].brdngPnt+"\n"+passanger[i].drpPnt+"\n"+passanger[i].price+"\n"+passanger[i].time);}
			}
}