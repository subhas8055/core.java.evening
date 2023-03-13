package com.xworkz.facebook;

public class Facebook {
	User user[] ;
	 int i;
		public Facebook( int size){
		user = new User[size];
		}
			public boolean signup(User user){
			System.out.println("signup start");
				boolean isAdded = false;
			if(user.userName != null && user.userName != ""){
			this.user[i++]=user;
			isAdded = true;
			
			}
			return isAdded;
			}
			public void get() {
				for(int i=0;i<user.length;i++) {
					System.out.println(i+"  "+user[i].userName+"  "+user[i].password+"  "+user[i].phoneNumber);
				}
			}
			
			
			public String login(long phonenumber,int passWord){
				System.out.println("login start");
			for(int i=0;i<user.length;i++){
				
				
				
			if(user[i].phoneNumber==phonenumber  && user[i].password==passWord){
			System.out.println("welcome to facebook");
					}
					else
					{System.out.println("invalid userName or password");
					}}
			
			
			return null;
			}


	}



