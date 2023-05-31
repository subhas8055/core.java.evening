package com.xworkz.mobiles.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xworkz.mobiles.dto.MobilesDTO;
import com.xworkz.mobiles.repo.MobileRepo;
@Service
public class MobileServiceImpl implements MobileService {
	@Autowired
	MobileRepo repo;

	@Override
	public MobilesDTO validateAndSave(MobilesDTO dto) {
		 boolean isBrandPresent = false;
		  boolean isColorPresent = false;
		  boolean isRamPresent = false;
		  boolean isPricePresent = false;


		  if(dto.getBrand() != null && !dto.getBrand().isEmpty()) {
		    isBrandPresent = true;
		    System.out.println(isBrandPresent);
		  }
		 
		  if(dto.getColor() != null && !dto.getColor().isEmpty()) {
		    isColorPresent = true;
		    System.out.println(isColorPresent);
		  }
		  
		  if(dto.getRam() != null && !dto.getRam().isEmpty()) {
		    isRamPresent = true;
		    System.out.println(isRamPresent);
		  }
		  
		  if(dto.getPrice() != 0 ) {
		    isPricePresent = true;
		    System.out.println(isPricePresent);
		  }
		  
		  if(isBrandPresent==true && isColorPresent==true &&  isRamPresent==true && isPricePresent==true) {
		System.out.println("7");
			  repo.save(dto);
		}
		return dto;
	}

	@Override
	public List<MobilesDTO> validateAndGet() {
		System.out.println("10");
		List<MobilesDTO> list =repo.get();
		return list;
	}

	@Override
	public List<MobilesDTO> validateAndGetByBrand(String brand) {
		// TODO Auto-generated method stub
		return repo.getByBrand(brand);
	}

	@Override
	public List<MobilesDTO> validateAndSearch(int price) {
		// TODO Auto-generated method stub
		return repo.getBYprice(price);
	}

	@Override
	public List<MobilesDTO> validateAndSearch1(String ram) {
		// TODO Auto-generated method stub
		return repo.getByRam(ram);
	}

	@Override
	public List<MobilesDTO> validateAndSearch2(String color) {
		// TODO Auto-generated method stub
		return repo.getByColor(color);
	}

	@Override
	public List<MobilesDTO> validateAndSearch3(String colors, String rams, String brand, int price) {
		// TODO Auto-generated method stub
		return repo.getByAll(colors,rams,brand,price);
	}

	@Override
	public MobilesDTO validateAndUpdate(int id) {
		// TODO Auto-generated method stub
		return repo.updateById(id);
	}

	@Override
	public MobilesDTO validateAndUpdate1(MobilesDTO dto) {
		// TODO Auto-generated method stub
		return repo.update(dto);
	}

	@Override
	public List<MobilesDTO> validateAndDelete(int id) {
		// TODO Auto-generated method stub
		return repo.delete(id);
	}

}
