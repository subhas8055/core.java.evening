package com.xworkz.spring.clients;

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
public class Clients {
	
	@Value("DMG")
	private String name;
	
	@Value("German")
	private String address;
	


}
