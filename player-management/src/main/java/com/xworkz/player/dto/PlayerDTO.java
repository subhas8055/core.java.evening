package com.xworkz.player.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@ToString
@NoArgsConstructor

public class PlayerDTO {
	private int id;
	private String name;
	private String game;
	private String country;
	private String dob;
}
