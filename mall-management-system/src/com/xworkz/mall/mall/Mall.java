package com.xworkz.mall.mall;

import com.xworkz.mall.shops.Shops;

public class Mall {
	Shops shop[];
	int i;
		public Mall(int size) {
			shop= new Shops[size];
		}
			public String shopping (Shops shop) {
				if (shop.getShopName()!= null) {
					this.shop[i++]=shop;
				}
			return "qaz";
			}
			public void getShop() {
				for(int i=0;i<shop.length;i++) {
					System.out.println(shop[i].getShopId()+"-"+shop[i].getShopName()+"-"+shop[i].getOwnerName()+"-"+shop[i].getNoOfShops());
				}
			}
			public void getshopDetailsById(String shopId) {
				for(int i=0;i<shop.length;i++) {
					if(shop[i].getShopId().equals(shopId))
					System.out.println(shop[i].getShopId()+"-"+shop[i].getShopName()+"-"+shop[i].getOwnerName()+"-"+shop[i].getNoOfShops());
				}
			}
			
			public void updateShopNameByshopId(String newName,String shopId) {
				for(int i=0;i<shop.length;i++) {
					if(shop[i].getShopId().equals(shopId)) {
					shop[i].setShopName(newName);
						System.out.println(shop[i].getShopId()+"-"+shop[i].getShopName()+"-"+shop[i].getOwnerName()+"-"+shop[i].getNoOfShops());
				}}
			}

}
