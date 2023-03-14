package com.xworkz.java_8.funinterface;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collector;
import java.util.stream.Collectors;

public class Testerr {
public static void main(String[] args) {
	List<Integer> list = new ArrayList<Integer>();
	list.add(12);
	list.add(23);
	list.add(34);
	list.add(45);
	System.out.println("= fetchng list");
	list.stream().forEach(a->System.out.println(a));
	System.out.println(" fetching filtered list of even number  with collect()=");

	System.out.println(list.stream().filter(a-> (a%2==0)).collect(Collectors.toList()));
	System.out.println(" filtered list of odd number with collect()");

	System.out.println(list.stream().filter(a-> (a%2!=0)).collect(Collectors.toList()));
	System.out.println(" filtered list of odd number with for each()");
			

list.stream().filter(a-> (a%2!=0)).forEach(a->System.out.println(a));
System.out.println(" filtered list of even number with for each()");

list.stream().filter(a-> (a%2==0)).forEach(a->System.out.println(a));
System.out.println("= = = = = =");


list.add(254);
list.add(653);
list.add(24);
list.add(111);
list.add(543);
list.add(872);
list.add(34);
list.add(75);
list.add(24);
list.add(309);
list.add(543);
list.add(347);
list.add(254);
list.add(7465);
list.add(24);
list.add(111);
list.add(64);
list.add(36);

System.out.println(" filtered list of  number greater then 100 with for each()");

list.stream().filter(a->(a>100)).forEach(a->System.out.println(a));
System.out.println(" filtered list of  number less then 100 with for each()");
list.stream().filter(a->(a<100)).forEach(a->System.out.println(a));


}
}
