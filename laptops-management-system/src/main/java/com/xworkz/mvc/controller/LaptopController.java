package com.xworkz.mvc.controller;

import java.lang.ProcessBuilder.Redirect;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.RedirectView;

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

	@PostMapping("/register")
	public String registerLaptop(@ModelAttribute LaptopDTO dto, HttpServletRequest req) {
		service.validateAndSave(dto);
		req.setAttribute("nam",dto.getName());
		return "success";
	}
	@GetMapping("/listoflaptops")
	public String getLaptop(HttpServletRequest req) {
		List<LaptopDTO> list=	service.validateAndGet();
		req.setAttribute("data",list);

		return "success2";

	}
	@GetMapping("/searchbyname")
	public  String searchByName(@RequestParam("names") String names,HttpServletRequest req) {
		List<LaptopDTO> list = service.validateAndSearch(names);

		req.setAttribute("data", list);



		return "success2";

	}
	@GetMapping("/searchbyram")
	public  String searchByRam(@RequestParam("ram") String ram,HttpServletRequest req) {
		List<LaptopDTO> list = service.validateAndSearch1(ram);

		req.setAttribute("data", list);
		return "success2";

	}
	@GetMapping("/searchbycolor")
	public  String searchByColor(@RequestParam("color") String color,HttpServletRequest req) {
		System.out.println(color);
		List<LaptopDTO> list = service.validateAndSearch2(color);

		req.setAttribute("data", list);



		return "success2";}
	@GetMapping("/searchbyall")
	public  String searchByAll(@RequestParam() String colors,String rams,String names,HttpServletRequest req) {
		List<LaptopDTO> list = service.validateAndSearch3(colors,rams,names);
		if(list!=null) {
			req.setAttribute("data", list);
			return "success2";
		}else {
			req.setAttribute("data", "NO DATA FOUND WITH GIVEN DETAILS");

		}
		return null;}

	@GetMapping("/update/{id}")
	public  String updateById(@PathVariable("id") int id,HttpServletRequest req) {
		LaptopDTO dto = service.validateAndUpdate(id);

		req.setAttribute("lap", dto);	
		RedirectView view = new RedirectView();
		view.setUrl(req.getContextPath()+"/ ");
		return "update";}

	@PostMapping("/updateandsave")
	public String updateById1(@ModelAttribute LaptopDTO dto,HttpServletRequest req) {
		LaptopDTO dto1 = service.validateAndUpdate1(dto);

		req.setAttribute("lap", dto1);	


		return "success";

	}
	@GetMapping("/delete/{id}")
	public  RedirectView deleteById(@PathVariable("id") int id,HttpServletRequest req) {

		List<LaptopDTO> list = service.validateAndDelete(id);

		req.setAttribute("data", list);	
		RedirectView view = new RedirectView();
		view.setUrl(req.getContextPath());
		view.setUrl(req.getContextPath()+"/listoflaptops ");
		return view ;
	}

}
