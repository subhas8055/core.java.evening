package com.xworkz.mobiles.repo;

import java.util.List;

import com.xworkz.mobiles.dto.MobilesDTO;

public interface MobileRepo {
	public void save(MobilesDTO dto);
	public List<MobilesDTO> get();
	public List<MobilesDTO> getByBrand(String brand);
	public List<MobilesDTO> getBYprice(int price);
	public List<MobilesDTO> getByRam(String ram);
	public List<MobilesDTO> getByColor(String color);
	public List<MobilesDTO> getByAll(String colors, String rams, String brand, int price);
	public MobilesDTO updateById(int id);
	public MobilesDTO update(MobilesDTO dto);
	public List<MobilesDTO> delete(int id);
}
