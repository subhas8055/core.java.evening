package com.xworkz.mvc.repository;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;

import com.xworkz.mvc.dto.AmusementParkDTO;

import lombok.Data;
@Component
@Data
public class AmusementParkRepoImpl implements AmusementParkRepo {

	List<AmusementParkDTO> list = new ArrayList<AmusementParkDTO>();
	@Override
	public AmusementParkDTO save(AmusementParkDTO dto) {
		System.out.println("inside repo");
		AmusementParkDTO dts = new AmusementParkDTO();
		if(dto != null) {
			System.out.println("dto is not null");
			try{
				list.add(dto);
			System.out.println("insertion done");}
			catch(Exception e) {
				e.printStackTrace();
			}
			System.out.println("park list added");
		dts=dto;
		}
		
		
		return dts;
	}

}
