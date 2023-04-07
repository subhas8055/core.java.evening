package com.xworkz.person.dto;

import com.xworkz.person.address.Address;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
public class Person {
	private int id;
	private String name;
	private Address address;
	

}
