package com.xworkz.mall.shops;
import lombok.Setter;
import lombok.Getter;
@Setter
@Getter

public class Shops {
	private String shopId;
	private String shopName;
	private String ownerName;
	private Integer noOfShops;
		public Shops(String shopId,String shopName,String ownerName,Integer noOfShops) {
			this.shopId=shopId;
			this.shopName=shopName;
			this.ownerName=ownerName;
			this.noOfShops=noOfShops;
			
		}
		
		
}
