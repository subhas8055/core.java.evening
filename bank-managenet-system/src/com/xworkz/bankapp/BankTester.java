package com.xworkz.bankapp;

import java.util.Collections;
import java.util.List;
import java.util.Scanner;

import com.xworkz.bankapp.bank.Bank;
import com.xworkz.bankapp.comparator.AccountNoComparator;
import com.xworkz.bankapp.comparator.ContactNoComparator;
import com.xworkz.bankapp.comparator.NameComparator;
import com.xworkz.bankapp.customer.Customer;
import com.xworkz.bankapp.customer.CustomerDTO;

public class BankTester extends Object {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		System.out.println("please enter size");
		int size = sc.nextInt();
		Bank bank = new Bank();
		for(int i=0;i<size;i++) {
		
		System.out.println("please enter name");
		String name = sc.next();
		System.out.println("please enter contactNo");
		long contactNo = sc.nextLong();
		System.out.println("please enter Account Id");
		int accountId = sc.nextInt();
		System.out.println("please enter account No");
		long accountNo = sc.nextLong();
		CustomerDTO customer = new CustomerDTO(name,accountNo,contactNo,accountId);
		bank.saveDetails(customer);}
		List<CustomerDTO> list = bank.getDetails();
		Collections.sort(list);
		System.out.println(list);
		Collections.sort(list, new NameComparator());
		System.out.println(list);
		Collections.sort(list, new ContactNoComparator());
		System.out.println(list);
		Collections.sort(list, new AccountNoComparator());
		System.out.println(list);
		
		
		System.out.println("enter 1 to fetch all customer details");
		System.out.println("enter 2 to get customers details  by using accountId ");
		System.out.println("enter 3 to get customer details by using name ");
		System.out.println("enter 4 to update customer name  by using account Id ");
		System.out.println("enter 5 to update contact number by using Id ");
		
		int option =sc.nextInt();
		switch(option) { 
		case 1:
			bank.getDetails();
		break ;
		
		case 2:
			System.out.println("please enter accounn Id");
			String accountID =sc.next();
			bank.getById(accountID);
			break ;
			
		case 3:
			System.out.println("please enter name to get details by name");
			String name1 =sc.next();
			bank.getByName(name1);
		break ;	
				
		case 4:
			System.out.println("please enter accountId to update name");
			String accountId1 =sc.next();
			System.out.println("please enter newName");
			String name2 =sc.next();
			
			bank.updateNameById(name2,accountId1);
			break ;
			
		case 5:
			System.out.println("please enter accountId to update number");
			String accountId2 =sc.next();
			System.out.println("please enter newNumber");
			long number =sc.nextLong();
			
			bank.updateNumberById(number,accountId2);		
	}

	}}
