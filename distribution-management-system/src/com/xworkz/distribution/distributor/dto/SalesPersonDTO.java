package com.xworkz.distribution.distributor.dto;

import java.io.Serializable;
import java.util.Comparator;

import com.xworkz.distribution.distributor.constant.Gender;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
@NoArgsConstructor
@Setter
@Getter
@ToString

public class SalesPersonDTO  implements Comparable<SalesPersonDTO> ,Serializable {
	private Integer id;
	private String name;
	private Long contactNo;
	private String location;
	private Gender gender;
//	@Override
//	public int hashCode() {
//		return id;
//	}

	@Override
	public int compareTo(SalesPersonDTO o) {
		// TODO Auto-generated method stub
		return this.id-o.id;
	}
	
	
	
}
