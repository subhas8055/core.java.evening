package com.xworkz.distribution;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;

import com.xworkz.distribution.comparator.NameComparator;
import com.xworkz.distribution.distributor.constant.Gender;
import com.xworkz.distribution.distributor.dto.SalesPersonDTO;
import com.xworkz.distribution.subhas.Distributor;
import com.xworkz.distribution.subhas.DistributorImpl;

public class Tester {
public static void main(String[] args) {
	Scanner sc=null;

	
		Distributor distributor =new DistributorImpl();
			
		sc=new Scanner(System.in);
		try {
			System.out.println("please enter the size");
			int size=sc.nextInt();
			for (int i = 0; i <size; i++) {
				
		SalesPersonDTO dt =new SalesPersonDTO();
		
		System.out.println("please enter id");
		dt.setId(sc.nextInt());
		System.out.println("please enter name");
		dt.setName(sc.next());
		System.out.println("please enter location");
		dt.setLocation(sc.next());
		System.out.println("please enter gender");
		dt.setGender(Gender.valueOf(sc.next()));
		System.out.println("please enter number");
		dt.setContactNo(sc.nextLong());
		
		distributor.save(dt);
		}
		
			List<SalesPersonDTO> list = distributor.getAll();
			System.out.println("list size is "+list.size());

			System.out.println("sort by id ");
	Collections.sort(list);
	for (SalesPersonDTO s : list) {
		System.out.println(s);
	}
	System.out.println("sort by name ");
		Collections.sort(list ,new NameComparator());
		for (SalesPersonDTO s : list) {
			System.out.println(s);
		}
//	System.out.println(list);
//		Iterator as=list.iterator();
//		while(as.hasNext()) {
//			Object w=as.next();
//			System.out.println(w);
//		}
	}catch(Exception e) {
		System.out.println("exception occured");
	}
	finally {
		if(sc!=null) {
			sc.close();
		}
	}
}
}
