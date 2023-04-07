package com.xworkz.maven.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter

public class TrainDTO {
	private int id ;
	private String name ;
	private String src ;
	private String destn ;

}
