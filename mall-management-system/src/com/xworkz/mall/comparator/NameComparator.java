package com.xworkz.mall.comparator;

import java.util.Comparator;

import com.xworkz.mall.shops.ShopsDTO;

public class NameComparator implements Comparator<ShopsDTO> {

	

	@Override
	public int compare(ShopsDTO o1, ShopsDTO o2) {
		// TODO Auto-generated method stub
		return o1.getShopName().compareTo(o2.getShopName());
	}

}
