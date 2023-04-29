package com.xworkz.mvc.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.xworkz.mvc.dto.LaptopDTO;
import com.xworkz.mvc.service.LaptopService;

@Controller
@RequestMapping("/")
public class LaptopController {
	@Autowired
	LaptopService service;
	
	public LaptopController() {
		System.out.println("LaptopController");
	}
	
	@PostMapping("/registerLaptop")
	public String registerLaptop(@ModelAttribute LaptopDTO dto, HttpServletRequest req) {
		System.out.println("inside registerLaptop ()");
		System.out.println("registering data");
		service.validateAndSave(dto);
		req.setAttribute("nam",dto.getName());
		
		
			
		return "success";
	}
	@GetMapping("/listoflaptops")
	public String getLaptop(HttpServletRequest req) {
		System.out.println("inside get method");
		List<LaptopDTO> str=	service.validateAndGet();
		req.setAttribute("data",str);
		return "success2";
		
	}
}
