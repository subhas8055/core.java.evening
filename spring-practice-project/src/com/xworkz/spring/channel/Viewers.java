package com.xworkz.spring.channel;

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
public class Viewers {
	
	@Value("India")
 private String countryName;
 
	
	@Value("Karnataka")
 private String stateName;



}
