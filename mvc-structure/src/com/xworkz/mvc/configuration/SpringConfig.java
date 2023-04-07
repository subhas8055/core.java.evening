package com.xworkz.mvc.configuration;

import java.util.ArrayList;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import com.xworkz.mvc.dto.AmusementParkDTO;

@Configuration
@ComponentScan(basePackages = "com.xworkz.mvc")
public class SpringConfig {
	@Bean
	public List<AmusementParkDTO> getLis(){
		return new ArrayList<AmusementParkDTO>();
	}
	
	@Bean
	public AmusementParkDTO getList(){
		AmusementParkDTO  dto = new AmusementParkDTO();
		dto.setId(1);
		dto.setName("wonderla");
		dto.setAddress("rajaji nagar");
		dto.setAreaOccupied("2Acres");
		dto.setEntryFees(1000);
		dto.setCity("banglore");
		
		return dto;
		
	}

}
