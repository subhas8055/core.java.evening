package com.xworkz.mall;

import java.util.Scanner;

import com.xworkz.mall.exception.ShopNotFoundException;
import com.xworkz.mall.mall.Mall;
import com.xworkz.mall.mall.Mantri;
import com.xworkz.mall.shops.Shops;

public class MallTester {
	public static void main(String[] args) {
		main();
	}
	public static void main() {
		Scanner scanner = new Scanner(System.in);
		System.out.println("please enter size");
		int size = scanner.nextInt();
		
		Mantri mall =new Mantri(size);

		for(int i=0;i<size;i++) {
			System.out.println("please enter shopId");
			String shopId = scanner.next();
			System.out.println("please enter shopName");
			String shopName = scanner.next();
			System.out.println("please enter ownerName");
			String ownerName=scanner.next();
			System.out.println("please enter noOf shops");
			int nos =scanner.nextInt();
			
				Shops shop =new Shops(shopId,shopName,ownerName,nos);
		mall.shopping(shop);}
		
		System.out.println("enter 1 to get all shop details");
		System.out.println("enter 2 to get shop details by Id");
		System.out.println("enter 3 to update shop name by Id");

		int option = scanner.nextInt();
		switch(option) {
		case 1:
			mall.getShop();
			break ;
			
			
		case 2:
			System.out.println("enter shop Id to get details");
			String shopId =scanner.next();
			try {
				mall.getshopDetailsById(shopId);
			} catch (ShopNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break ;
			
		case 3:
			System.out.println("enter shop Id to get details");
			String shopId1 =scanner.next();
			System.out.println("enter new name shop Id to get details");
			String newName =scanner.next();
			mall.updateShopNameByshopId(newName,shopId1);
			break ;
			
			
		}
		
		
		
	}

}
