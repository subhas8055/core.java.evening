package com.xworkz.abstrac.institute;

import com.xworkz.abstrac.shop.Shop;

public class JuiceShop implements Shop{

	@Override
	public long doBusiness() {
		System.out.println("bul bul matadakkilva");
		return 987654321L;
	}

}
