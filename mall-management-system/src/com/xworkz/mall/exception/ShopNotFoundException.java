package com.xworkz.mall.exception;

public class ShopNotFoundException extends Exception {
	String message;
public ShopNotFoundException(String message) {
this.message = message;
}
}
