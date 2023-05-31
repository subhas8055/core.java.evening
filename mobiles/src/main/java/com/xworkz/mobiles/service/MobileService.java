package com.xworkz.mobiles.service;

import java.util.List;

import com.xworkz.mobiles.dto.MobilesDTO;

public interface MobileService {
	
	public MobilesDTO validateAndSave(MobilesDTO dto);
	public List<MobilesDTO> validateAndGet();
	public List<MobilesDTO> validateAndGetByBrand(String brand);
	public List<MobilesDTO> validateAndSearch(int price);
	public List<MobilesDTO> validateAndSearch1(String ram);
	public List<MobilesDTO> validateAndSearch2(String color);
	public List<MobilesDTO> validateAndSearch3(String colors, String rams, String brand, int price);
	public MobilesDTO validateAndUpdate(int id);
	public MobilesDTO validateAndUpdate1(MobilesDTO dto);
	public List<MobilesDTO> validateAndDelete(int id);


}
