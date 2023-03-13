package com.xworkz.collections;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

public class CollectTester {
public static void main(String[] args) {
	Collection list = new ArrayList();
	list.add("rowdy mla");
	list.add("karala ratri");
	list.add(30);
	
	System.out.println(list.contains("rowdy mla"));
	System.out.println(list.size());
	System.out.println(list.remove(30));
	System.out.println(list);
	list.clear();
	list.retainAll(list);
	System.out.println(list);
	list.isEmpty();
	System.out.println(list.remove("rowdy mla"));
	list.add(89.90);
	System.out.println(list);
	list.add("subhas");
	list.add("satish");
	list.add("likith");
	list.add("rudresh");
	list.add("kiran");
	list.add("vijay");
	list.add("prashant");
	list.add("vishal");
	list.add("darshan");
	list.add("pawan");
	list.add(8548058481L);
	list.add(9876543210L);
	list.add(8765432109L);
	list.add(7654321098L);
	list.add(6543210987L);
	list.add(5432109876L);
	list.add(4321098765L);
	list.add(3210987654L);
	list.add(2109876543L);
	list.add(1098765432L);
	list.add('A');
	list.add('B');
	list.add('C');
	list.add('D');
	list.add('E');
	list.add('F');
	list.add('G');
	list.add('H');
	list.add('I');
	list.add('J');
	list.add('K');
	list.remove(89.9);
	System.out.println(list);

	System.out.println(list.contains("subahs"));
	System.out.println(list.size());
	System.out.println(list.remove('D'));
	System.out.println(list);
	
	
	list.isEmpty();
	System.out.println(list.remove("darshan"));
	
	
}
}
