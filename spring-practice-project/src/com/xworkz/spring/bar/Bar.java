package com.xworkz.spring.bar;

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
public class Bar {
	@Value("Pooja Bar ")
	private String barName;
	
	@Autowired
	private Waiter waiter;
}
