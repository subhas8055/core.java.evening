package com.xworkz.laptopapp.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@ToString
@AllArgsConstructor
public class LaptopDTO {
	private int id;
	private String name;
	private String color;
	private String ram;

}
