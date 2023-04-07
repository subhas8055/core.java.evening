package com.xworkz.spring.gun;


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
public class Bullets {
 
	@Value("12")
	private int numOfBullets;
	
	@Value("22LR, .380 ACP, 9mm")
	private String calibers;
}
