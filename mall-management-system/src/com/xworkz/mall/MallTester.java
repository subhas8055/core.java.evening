package com.xworkz.mall;

import java.util.Collections;
import java.util.List;
import java.util.Scanner;

import com.xworkz.mall.comparator.NameComparator;
import com.xworkz.mall.comparator.NumberComparator;
import com.xworkz.mall.comparator.OwnerComparator;
import com.xworkz.mall.exception.ShopNotFoundException;
import com.xworkz.mall.mall.Mall;
import com.xworkz.mall.mall.Mantri;
import com.xworkz.mall.shops.ShopsDTO;

public class MallTester {
	public static void main(String[] args) {
		main();
	}
	public static void main() {
		Scanner scanner = new Scanner(System.in);
		System.out.println("please enter size");
		int size = scanner.nextInt();
		
		Mantri mall =new Mantri();

		for(int i=0;i<size;i++) {
			System.out.println("please enter shopId");
			int shopId = scanner.nextInt();
			System.out.println("please enter shopName");
			String shopName = scanner.next();
			System.out.println("please enter ownerName");
			String ownerName=scanner.next();
			System.out.println("please enter noOf shops");
			int nos =scanner.nextInt();
			
				ShopsDTO shop =new ShopsDTO(shopId,shopName,ownerName,nos);
		mall.shopping(shop);}
		List<ShopsDTO> list = mall.getShop();
		Collections.sort(list);
		
		Collections.sort(list, new NameComparator());
		
		Collections.sort(list, new OwnerComparator());
		
		Collections.sort(list, new NumberComparator());
		
		
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
			int shopId =scanner.nextInt();
			try {
				mall.getshopDetailsById(shopId);
			} catch (ShopNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break ;
			
		case 3:
			System.out.println("enter shop Id to get details");
			int shopId1 =scanner.nextInt();
			System.out.println("enter new name shop Id to get details");
			String newName =scanner.next();
			mall.updateShopNameByshopId(newName,shopId1);
			break ;
			
			
		}
		
		
		
	}

}
