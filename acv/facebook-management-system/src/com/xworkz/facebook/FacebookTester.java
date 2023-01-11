package com.xworkz.facebook;

import java.util.Scanner;

public class FacebookTester {
	public static void main(String S[]){
		
		Scanner scanner =new Scanner(System.in);
		System.out.println("please enter the size");
		int size =scanner.nextInt();
		Facebook facebook = new Facebook(size);
		for(int i=0;i<size;i++){

		System.out.println("please enter the userName");
		String userName = scanner.next();
		System.out.println("please enter the password");
		int password = scanner.nextInt();
		System.out.println("please enter the phoneNumber");
		long phoneNumber = scanner.nextLong();
		User user =new User(userName,password,phoneNumber);
		facebook.signup(user);}
		facebook.get();
		System.out.println("please enter phoneNumber");
		long phonenumber =scanner.nextLong();
				System.out.println("please enter password");
		int passWord =scanner.nextInt();
		
facebook.login(phonenumber,passWord);


		scanner.close();}



}
