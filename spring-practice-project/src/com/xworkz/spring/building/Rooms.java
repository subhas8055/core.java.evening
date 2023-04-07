package com.xworkz.spring.building;

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
	public class Rooms{
		
		@Value("1")
		private int roomNo;
		
		@Value("3rd floor")
		private String floorNo;
		
		@Value("8528528523")
		private long contactNo;
}
