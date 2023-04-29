package com.xworkz.mvc.service;

import java.util.List;

import com.xworkz.mvc.dto.LaptopDTO;

public interface LaptopService {
	public LaptopDTO validateAndSave(LaptopDTO dto);

	public List<LaptopDTO> validateAndGet();
}
