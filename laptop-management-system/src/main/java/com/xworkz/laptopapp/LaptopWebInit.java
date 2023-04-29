package com.xworkz.laptopapp;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import com.xworkz.laptopapp.config.SpringConfig;

public class LaptopWebInit extends AbstractAnnotationConfigDispatcherServletInitializer {

	@Override
	protected Class<?>[] getRootConfigClasses() {
		System.out.println("1");
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
System.out.println("2");	
return new Class[] {SpringConfig.class};
	}

	@Override
	protected String[] getServletMappings() {
System.out.println("3");		
return new String[] {"/"};
	}

}
