package com.xworkz.mvc.service;

import java.util.List;

import com.xworkz.mvc.dto.LaptopDTO;

public interface LaptopService {
	public LaptopDTO validateAndSave(LaptopDTO dto);

	public List<LaptopDTO> validateAndGet();

	public List<LaptopDTO> validateAndSearch(String names);

	public List<LaptopDTO> validateAndSearch1(String ram);

	public List<LaptopDTO> validateAndSearch2(String color);

	public LaptopDTO validateAndUpdate(int id);

	public LaptopDTO validateAndUpdate1(LaptopDTO dto);
}
