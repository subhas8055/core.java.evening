package com.xworkz.mobiles.config;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebInit extends AbstractAnnotationConfigDispatcherServletInitializer{

	@Override
	protected Class<?>[] getRootConfigClasses() {
		System.out.println("1");	
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
