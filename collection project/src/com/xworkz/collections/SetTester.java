package com.xworkz.collections;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Set;
import java.util.TreeSet;

public class SetTester {
	public static void main(String[] args) {
		Set s= new HashSet();

//s.add(null);
		s.add("Subhas");
		s.add("vishal");
		s.add("Vijay");
		s.add("likith");
		s.add(1);
		System.out.println(s.add("Vijay"));
		//s.add(null);
		System.out.println(s);
		System.out.println("before iterator");
		for (Object object : s) {
			System.out.println(object);	
		}
		System.out.println();
		System.out.println("after iterator");

		Iterator d =s.iterator();
		System.out.println(d.hasNext());

		while(d.hasNext()) {
			Object w=d.next();
			System.out.println(w);		
		}
		Iterator d1 =s.iterator();
		
		System.out.println("hi");
		
		
	}
}





