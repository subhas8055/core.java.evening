package com.xworkz.spring.juice;


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
public class Fruits  {
	
	@Value("Apple")
	private String appleJuice1;
	
	@Value("Pineapple")
	private String pineappleJuice2;
	
	@Value("Orange")
	private String orangeJuice3;
	
	@Value("Mango")
	private String mangoJuice4;

}
