package com.xworkz.mall.shops;
import lombok.Setter;

import java.io.Serializable;

import lombok.Getter;
@Setter
@Getter

public class ShopsDTO implements Serializable,Comparable<ShopsDTO> {
	private int shopId;
	private String shopName;
	private String ownerName;
	private Integer noOfShops;
		public ShopsDTO(int shopId,String shopName,String ownerName,Integer noOfShops) {
			this.shopId=shopId;
			this.shopName=shopName;
			this.ownerName=ownerName;
			this.noOfShops=noOfShops;
			
		}
		@Override
		public String toString() {
			return "Shops [shopId=" + shopId + ", shopName=" + shopName + ", ownerName=" + ownerName + ", noOfShops="
					+ noOfShops + "]";
		}
		@Override
		public int compareTo(ShopsDTO o) {
			// TODO Auto-generated method stub
			return this.getShopId()-o.shopId ;
		}
		
		
}
