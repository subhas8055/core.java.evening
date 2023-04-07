package com.xworkz.mvc.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xworkz.mvc.dto.AmusementParkDTO;
import com.xworkz.mvc.service.AmusementParkService;

import lombok.ToString;

@Component
@ToString
public class AmusementParkController {
	
	
	@Autowired
	private AmusementParkService service;
	
	
	public AmusementParkDTO process(AmusementParkDTO dto) {
		System.out.println("inside process");
		
		try{
			if(dto != null) {
				System.out.println("calling service");
			service.validateAndSave(dto);
			
			}else {
				System.out.println("dto is null");
			}
		}catch(Exception e){
		System.out.println("exception");
		e.printStackTrace();
	}
	
		
		
		
		return dto;
		
	}
	
}
