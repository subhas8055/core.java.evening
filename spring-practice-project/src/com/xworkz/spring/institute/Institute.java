package com.xworkz.spring.institute;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.xworkz.addressapp.task1.house.Doors;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
@Component
public class Institute {

	@Value("BNM institute of technology")
	private String name;
	
	@Autowired
	private Branches branchesAvailable;
}
