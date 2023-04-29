package com.xworkz.laptopapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.xworkz.laptopapp.dto.LaptopDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/")
public class LaptopController {
	@PostMapping("/registerLaptop")
	public String registerLaptop(@ModelAttribute LaptopDTO dto, HttpServletRequest req) {
		System.out.println("inside registerLaptop ()");
		if(dto != null) {
			System.out.println("registering data");
			req.setAttribute("nam", dto.getName());
			return "success.jsp";
		}
		
		return "failure";
		
	}

}
