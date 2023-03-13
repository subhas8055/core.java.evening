package com.xworkz.apps;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor

public class Bar {

	private int id;
	private String name;
	private String location;
	private String owner;
	
	
	
	@Override
	public String toString() {
		return "Bar [id=" + this.id + ", name=" + this.name + ", location=" + this.location + ", owner=" + this.owner + "]";
	}
	

public boolean equals(Object obj) {
	Bar bar = (Bar)obj;
	if( this.id == bar.id && this.name.equals(bar.name)) {
		return true;
	}
	return false;
	
}
public void add(int a,int b) {
	System.out.println("add start");
	try {
	System.out.println(a/b);
	}catch(ArithmeticException e) {
		System.out.println("can't do that ");
	}
	System.out.println("add end ");
}
}
