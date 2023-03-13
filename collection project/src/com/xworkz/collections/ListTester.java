package com.xworkz.collections;

import java.util.ArrayList;
import java.util.List;

public class ListTester {
	static int a=4;
public static void main(String[] args) {
	List list = new ArrayList();
	List list1= new ArrayList();
	
	list.add(0,"subhas");
	list.add(1,'S');
	list.add(2,25);
	list.add(3, 'K');
	list.add(4,null);
	list.add(5,null);
	list.add(6,'K');
	System.out.println(list);
	list1.add( "Vishal");
	list1.add(1, 'V');
	list1.add(2,25);
	list1.add(3, 'B');
	list1.add(null);
	list1.add(5, null);
	list1.add(6, 'B');
	System.out.println(list1);
	System.out.println("=====");
	list.addAll(list1);
	System.out.println(list);
	System.out.println("=======");
	System.out.println(list1);
	System.out.println(list.containsAll(list1));
	System.out.println(list1.containsAll(list));
	System.out.println(list1.removeAll(list));
	System.out.println("=====");
	System.out.println(list);
	System.out.println("=======");
	System.out.println(list1);
	System.out.println(list.removeAll(list1));
	ListTester l =null;
	System.out.println(l.a);
	
	
}
}
