package com.xworkz.mobiles.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
@ComponentScan(basePackages = "com.xworkz.mobiles")
public class SpringConfig {
	@Bean
	public ViewResolver getViewResolver() {
		return new InternalResourceViewResolver("/",".jsp");
		
	}
	@Bean
	public LocalContainerEntityManagerFactoryBean getLocalContainerEntityManagerFactoryBean() {
		return new LocalContainerEntityManagerFactoryBean();
	}
}
