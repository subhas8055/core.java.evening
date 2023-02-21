package com.xworkz.mall.mall;

import com.xworkz.mall.exception.ShopNotFoundException;
import com.xworkz.mall.shops.Shops;

public class Mantri implements Mall
{

	Shops shop[];
	int i;
		public Mantri(int size) {
			shop= new Shops[size];
		}
		@Override
		public String shopping(Shops shop) {
			if (shop.getShopName()!= null) {
				this.shop[i++]=shop;}
			return null;
		}
		@Override
		public void getShop() {
			for (Shops s : shop) {
				System.out.println(s);
			}
		}
		@Override
		public void getshopDetailsById(String shopId) throws ShopNotFoundException{
			for (Shops s : shop) {
				if(s.getShopId().equals(shopId))
			//	System.out.println(s.getShopId()+"-"+s.getShopName()+"-"+s.getOwnerName()+"-"+s.getNoOfShops());
			System.out.println(s);
			}
			 if(i<shop.length-1) {
				throw new ShopNotFoundException("Shop not found with given shopId ");
			}
		}
		@Override
		public void updateShopNameByshopId(String newName, String shopId) {
			for (Shops s : shop) {
				if(s.getShopId().equals(shopId)) {
				s.setShopName(newName);
	System.out.println(s);
				//	System.out.println(s.getShopId()+"-"+s.getShopName()+"-"+s.getOwnerName()+"-"+s.getNoOfShops());
			}}			
		}

}

