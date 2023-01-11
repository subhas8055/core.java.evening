package com.xworkz.mall.shops;

public class Shops {
	private String shopId;
	private String shopName;
	private String ownerName;
	private int noOfShops;
		public Shops(String shopId,String shopName,String ownerName,int noOfShops) {
			this.shopId=shopId;
			this.shopName=shopName;
			this.ownerName=ownerName;
			this.noOfShops=noOfShops;
			
		}
		public void setShopId(String shopId) {
			this.shopId=shopId;
		}
		public String getShopId() {
			return shopId;
		}
		public void setShopName(String shopName) {
			this.shopName=shopName;
		}
		public String getShopName() {
			return shopName;
		}
		public void setOwnerName(String ownerName) {
			this.ownerName=ownerName;
		}
		public String getOwnerName() {
			return ownerName;
		}
		public void setNoOfShops(int noOfShops) {
			this.noOfShops=noOfShops;
		}
		public int getNoOfShops() {
			return noOfShops;
		}
		
}
