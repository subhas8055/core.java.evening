package com.xworkz.airport.exception;

public class TerminalNotFoundException extends Exception {
	String message;
public TerminalNotFoundException(String message ) {
	this.message =message;
	}
}
