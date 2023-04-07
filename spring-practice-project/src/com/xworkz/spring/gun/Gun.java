package com.xworkz.spring.gun;


import org.springframework.beans.factory.annotation.Autowired;
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
public class Gun {
	
	@Value("Hand Gun")
	private String gunType;
	
	@Autowired
	private Bullets bullets;

}
