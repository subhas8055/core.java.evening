package com.xworkz.mvc.repo;

import java.util.List;

import com.xworkz.mvc.dto.LaptopDTO;

public interface LaptopRepo {

	public void save(LaptopDTO dto);

	public List<LaptopDTO> getLaptop();

	public List<LaptopDTO> searchLaptop(String names);

	public List<LaptopDTO> searchLaptop1(String ram);

	public List<LaptopDTO> searchLaptop2(String color);

	public LaptopDTO updateById(int id);

	public LaptopDTO update(LaptopDTO dto);

	public List<LaptopDTO> deleteById(int id);

	public List<LaptopDTO> search(String colors, String rams, String names);
	
}
