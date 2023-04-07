package com.xworkz.spring.team;


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
public class Players  {
	
	@Value("Virat Kohli")
	private String name;
	
	@Value("18")
	private int jerseyNo;
	
	@Value("32")
	private int age;
}
