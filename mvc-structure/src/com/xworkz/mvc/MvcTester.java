package com.xworkz.mvc;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import com.xworkz.mvc.configuration.SpringConfig;
import com.xworkz.mvc.controller.AmusementParkController;
import com.xworkz.mvc.dto.AmusementParkDTO;

public class MvcTester {
	public static void main(String[] args) {
			ApplicationContext ac = new AnnotationConfigApplicationContext(SpringConfig.class);
			AmusementParkController amc = ac.getBean(AmusementParkController.class);
			AmusementParkDTO dto = ac.getBean(AmusementParkDTO.class);
			amc.process(dto);
			System.out.println(amc);
		
	}
}
