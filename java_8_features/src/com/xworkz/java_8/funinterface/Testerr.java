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
	System.out.println("=");
	list.stream().forEach(a->System.out.println(a));
	System.out.println("= =");

	System.out.println(list.stream().filter(a-> (a%2==0)).collect(Collectors.toList()));
	System.out.println("= = =");

	System.out.println(list.stream().filter(a-> (a%2!=0)).collect(Collectors.toList()));
	System.out.println("= = = =");

list.stream().filter(a-> (a%2!=0)).forEach(a->System.out.println(a));
System.out.println("= = = = =");

list.stream().filter(a-> (a%2==0)).forEach(a->System.out.println(a));

}
}
