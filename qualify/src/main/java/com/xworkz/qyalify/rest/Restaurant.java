package main.java.com.xworkz.qyalify.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;


@Component
public interface Restaurant {

	
	 default String serve() {
		return "Restaurant";
		
	}
}
