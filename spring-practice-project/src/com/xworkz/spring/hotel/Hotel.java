package com.xworkz.spring.hotel;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@NoArgsConstructor
@Component
public class Hotel {
	
	@Value("shanthi Sagar")
	private String hotelName;
	
	@Autowired
	private Chef chef;
	
}
