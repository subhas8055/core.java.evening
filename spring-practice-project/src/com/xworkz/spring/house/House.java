package com.xworkz.spring.house;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
@Component
public class House{
	
	@Value("Kushi Nilaya")
	private String houseName;
	
	@Autowired
	private Doors doors;

}
