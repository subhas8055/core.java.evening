package com.xworkz.mall;

public class MallTester {
	public static void main(String[] args) {
		Mall mall =new Mall();
		Shops shop =new Shops("shp1","laptop store","xyz",07);
		mall.shopping(shop);
		mall.getshop();
		
	}

}
