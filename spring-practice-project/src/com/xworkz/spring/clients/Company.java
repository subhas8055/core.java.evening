package com.xworkz.spring.clients;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.val;

@Setter
@Getter
@NoArgsConstructor
@ToString
@Component
public class Company {
	
	@Value("Accutech")
	private String companyName;
	
	@Autowired
	private Clients clients;

}
