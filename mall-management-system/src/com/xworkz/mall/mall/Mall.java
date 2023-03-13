package com.xworkz.mall.mall;

import java.util.List;

import com.xworkz.mall.exception.ShopNotFoundException;
import com.xworkz.mall.shops.ShopsDTO;

public interface Mall {
	
			public String shopping (ShopsDTO shop);
			public List<ShopsDTO> getShop();
			public List<ShopsDTO> getshopDetailsById(int shopId) throws ShopNotFoundException;
			public List<ShopsDTO> updateShopNameByshopId(String newName,int shopId) ;
			}
