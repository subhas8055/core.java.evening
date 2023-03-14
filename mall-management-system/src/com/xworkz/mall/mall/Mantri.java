package com.xworkz.mall.mall;

import java.util.ArrayList;
import java.util.List;

import com.xworkz.mall.exception.ShopNotFoundException;
import com.xworkz.mall.shops.ShopsDTO;

public class Mantri implements Mall
{
List<ShopsDTO> list = new ArrayList<ShopsDTO>();
		@Override
		public String shopping(ShopsDTO shop) {
			if (shop.getShopName()!= null) {
				list.add(shop);}
			return null;
		}
		
		@Override
		public List<ShopsDTO> getShop() {
			for (ShopsDTO s : list) {
				System.out.println(s);
			}
			return list;
		}
		@Override
		public List<ShopsDTO> getshopDetailsById(int shopId) throws ShopNotFoundException{
			for (ShopsDTO s : list) {
				if(s.getShopId()==shopId)
			//	System.out.println(s.getShopId()+"-"+s.getShopName()+"-"+s.getOwnerName()+"-"+s.getNoOfShops());
			System.out.println(s);
			}
//			 if(i<shop.length-1) {
//				throw new ShopNotFoundException("Shop not found with given shopId ");
//			}
			return list;
		}
		@Override
		public List<ShopsDTO> updateShopNameByshopId(String newName, int shopId) {
			for (ShopsDTO s : list) {
				if(s.getShopId()==shopId) {
				s.setShopName(newName);
	System.out.println(s);
				//	System.out.println(s.getShopId()+"-"+s.getShopName()+"-"+s.getOwnerName()+"-"+s.getNoOfShops());
			}}
			return list;			
		}

}

