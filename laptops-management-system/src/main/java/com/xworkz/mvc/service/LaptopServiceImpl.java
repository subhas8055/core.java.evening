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

		}else {
			System.out.println("data is empty");
		}

		return dto;
	}
	@Override
	public List<LaptopDTO> validateAndGet() {
		List<LaptopDTO> list  =repo.getLaptop();
		return list;
	}
	@Override
	public List<LaptopDTO> validateAndSearch(String names) {
		List<LaptopDTO> list  =repo.searchLaptop(names);

		return list;
	}
	@Override
	public List<LaptopDTO> validateAndSearch1(String ram) {
		System.out.println(ram);
		List<LaptopDTO> list =repo.searchLaptop1(ram);
		return list;
	}
	@Override
	public List<LaptopDTO> validateAndSearch2(String color) {
		System.out.println(color);
		List<LaptopDTO> list =repo.searchLaptop2(color);
		return list;
	}
	@Override
	public LaptopDTO validateAndUpdate(int id) {
		LaptopDTO dto =repo.updateById(id);
		return dto;
	}
	@Override
	public LaptopDTO validateAndUpdate1(LaptopDTO dto) {
		LaptopDTO dt= new LaptopDTO();
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
			dt = repo.update(dto);

		}

		return dt;
	}
	@Override
	public List<LaptopDTO> validateAndDelete(int id) {

		return repo.deleteById(id);


	}
	@Override
	public List<LaptopDTO> validateAndSearch3(String colors, String rams, String names) {
		return repo.search(colors,rams,names);
	}



}

