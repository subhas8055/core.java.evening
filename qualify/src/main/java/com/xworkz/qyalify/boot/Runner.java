package main.java.com.xworkz.qyalify.boot;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import main.java.com.xworkz.qyalify.config.SpringConfig;
import main.java.com.xworkz.qyalify.rest.Owner;

public class Runner {
	
	public static void main(String[] args) {
		
	
	ApplicationContext ac = new AnnotationConfigApplicationContext(SpringConfig.class);
	 Owner o=ac.getBean(Owner.class);
	 System.out.println(o);
	}
}
