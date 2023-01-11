package com.xworkz.mall.mall;

import com.xworkz.mall.shops.Shops;

public class Mall {
	Shops shop[];
	int i;
		public Mall(int size) {
			shop= new Shops[size];
		}
			public String shopping (Shops shop) {
				if (shop.shopName!= null) {
					this.shop[i++]=shop;
				}
			return "qaz";
			}
			public void getshop() {
				for(int i=0;i<shop.length;i++) {
					System.out.println(shop[i].shopId+"-"+shop[i].shopName+"-"+shop[i].ownerName+"-"+shop[i].noOfShops);
				}
			}

}
