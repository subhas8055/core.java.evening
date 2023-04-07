package com.xworkz.spring.institute;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.xworkz.addressapp.task1.house.Doors;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
@Component
public class Branches  {

	@Value("Mechanical Engineering")
	private String b1;
	
	@Value("Computer science Engineering")
	private String b2;
	
	
	@Value("Electronics and comunication Engineering")
	private String b3;
	
	@Value("Civil Engineering")
	private String b4;
}
