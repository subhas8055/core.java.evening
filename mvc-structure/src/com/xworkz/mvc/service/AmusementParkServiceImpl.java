package com.xworkz.mvc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xworkz.mvc.dto.AmusementParkDTO;
import com.xworkz.mvc.repository.AmusementParkRepo;

import lombok.Data;

@Component
@Data

public class AmusementParkServiceImpl implements AmusementParkService {

	@Autowired
	 private AmusementParkRepo repo;

	@Override
	public AmusementParkDTO validateAndSave(AmusementParkDTO dto) {
		System.out.println("inside service");
		AmusementParkDTO dt = new AmusementParkDTO();
boolean isIdPresent = false;
boolean isnamePresent = false;
boolean isCityPresent = false;
boolean isAreaPresent = false;
boolean isEntryFeesPresent = false;
boolean isAddressPresent = false;

if(dto.getId() > 0) {
	isIdPresent=true;
}

if(dto.getName()!= null &&  !dto.getName().isEmpty()) {
	isnamePresent=true;
}


if(dto.getAddress()!= null &&  !dto.getAddress().isEmpty()) {
	isAddressPresent=true;
}


if(dto.getAreaOccupied()!= null &&  !dto.getAreaOccupied().isEmpty()) {
	isAreaPresent=true;
}

if(dto.getCity()!= null &&  !dto.getCity().isEmpty()) {
	isCityPresent=true;
}

if(dto.getEntryFees()!= 0 &&  !dto.getAddress().isEmpty()) {
	isEntryFeesPresent=true;
}
if(isAddressPresent ==true &&isAreaPresent == true &&isCityPresent ==true && isEntryFeesPresent==true && isIdPresent ==true && isnamePresent == true) {
	System.out.println("calling repo");
	dt=repo.save(dto);
	System.out.println("validation done");
}

return dt;
	}
}
