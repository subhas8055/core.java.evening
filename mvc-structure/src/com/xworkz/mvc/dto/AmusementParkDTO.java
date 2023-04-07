package com.xworkz.mvc.dto;

import java.io.Serializable;

import org.springframework.stereotype.Component;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
@Setter
@Getter
@AllArgsConstructor

@ToString
@NoArgsConstructor
public class AmusementParkDTO  implements Serializable{

	private int id;
	private String name;
	private String address;
	private String city;
	private double entryFees;
	private String areaOccupied;
	
}
