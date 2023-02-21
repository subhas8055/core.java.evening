package com.xworkz.railway.exception;

public class PlatformNotFoundException extends Exception {
	String reply;
public PlatformNotFoundException(String reply) {
this.reply=reply;}
}
