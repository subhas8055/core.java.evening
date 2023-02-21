package com.xworkz.mall.mall;

import com.xworkz.mall.exception.ShopNotFoundException;
import com.xworkz.mall.shops.Shops;

public interface Mall {
	
			public String shopping (Shops shop);
			public void getShop();
			public void getshopDetailsById(String shopId) throws ShopNotFoundException;
			public void updateShopNameByshopId(String newName,String shopId) ;
			}
