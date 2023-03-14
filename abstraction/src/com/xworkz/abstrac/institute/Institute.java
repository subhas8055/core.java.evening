package com.xworkz.abstrac.institute;

import com.xworkz.abstrac.shop.Shop;

public class Institute implements Shop {

	@Override
	public long doBusiness() {
		System.out.println("hi buddy en business madtiya");
		return 98765L;
	}

}
