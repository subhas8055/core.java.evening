package com.xworkz.mall;

public class Mall {
	Shops shop[]= new Shops[1];
	int i;
		public Mall() {
			
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
