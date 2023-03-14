package com.xworkz.paints.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@NoArgsConstructor
@ToString

public class AirportDTO {
	private String name;
	private int noOfTerminals;
	private int noOfEmployees;
	private String city;
	private double area;
}
