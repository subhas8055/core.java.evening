package com.xworkz.mvc.repo;

import java.util.List;

import com.xworkz.mvc.dto.LaptopDTO;

public interface LaptopRepo {

	public LaptopDTO save(LaptopDTO dto);

	public List<LaptopDTO> getLaptop();
	
}
