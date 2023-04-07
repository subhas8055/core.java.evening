package com.xworkz.spring.hotel;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@NoArgsConstructor
@ToString
@Component
public class Chef  {
	
	@Value("1")
	private int id;
	
	@Value("Krish")
	private String name;
	
	@Value("28")
	private int age;
}
