package com.xworkz.spring.bar;

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
public class Waiter {

	@Value("Vinod")
	private String name;
	
	@Value("31")
	private int age;
	
	@Value("9874563212")
	private long contactNo;
}
