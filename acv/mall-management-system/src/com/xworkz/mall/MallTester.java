package com.xworkz.mall;

import java.util.Scanner;

import com.xworkz.mall.mall.Mall;
import com.xworkz.mall.shops.Shops;

public class MallTester {
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		System.out.println("please enter size");
		int size = scanner.nextInt();
		
		Mall mall =new Mall(size);

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
		mall.getshop();
		
	}

}
