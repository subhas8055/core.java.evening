package com.xworkz.mvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xworkz.mvc.dto.LaptopDTO;
import com.xworkz.mvc.repo.LaptopRepo;
@Service
public class LaptopServiceImpl implements LaptopService{
	@Autowired
	LaptopRepo repo;
	@Override
	public LaptopDTO validateAndSave(LaptopDTO dto) {
		 boolean isNamePresent = false;
		  boolean isColorPresent = false;
		  boolean isRamPresent = false;
		  

		  if(dto.getName() != null && !dto.getName().isEmpty()) {
		    isNamePresent = true;
		  }
		 
		  if(dto.getColor() != null && !dto.getColor().isEmpty()) {
		    isColorPresent = true;
		  }
		  
		  if(dto.getRam() != null && !dto.getRam().isEmpty()) {
		    isRamPresent = true;
		  }
		  
		  if(isNamePresent==true && isColorPresent==true &&  isRamPresent==true) {
			  repo.save(dto);
		  
		  }
		
		return dto;
	}
	@Override
	public List<LaptopDTO> validateAndGet() {
List<LaptopDTO> list  =repo.getLaptop();
		return list;
	}}

