package com.xworkz.mobiles.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.RedirectView;

import com.xworkz.mobiles.dto.MobilesDTO;
import com.xworkz.mobiles.service.MobileService;
import com.xworkz.mvc.dto.LaptopDTO;

@Controller
@RequestMapping("/")
public class MobileController {
	@Autowired
	MobileService service;
	
	@PostMapping("/register")
	public String register(@ModelAttribute MobilesDTO dto,HttpServletRequest req) {
		System.out.println("5");
		if(dto!=null) {
			System.out.println("6");
			service.validateAndSave(dto);
			req.setAttribute("mob", dto.getBrand());
		}
		return "success";	
	}
	@GetMapping("/listofmobiles")
	public String getMObiles(HttpServletRequest req) {
		System.out.println("9");
		List<MobilesDTO> list= service.validateAndGet();
		System.out.println("12");
		req.setAttribute("get", list);

		return "success2";
	}
	@GetMapping("/searchbybrand")
	public String getMObilesByBrand(@RequestParam("brand") String brand, HttpServletRequest req) {
		System.out.println("9");
		List<MobilesDTO> list= service.validateAndGetByBrand(brand);
		System.out.println("12");
		req.setAttribute("get", list);

		return "success2";
	}
	
	
	@GetMapping("/searchbyprice")
	public  String searchByPrice(@RequestParam("price") int price,HttpServletRequest req) {
		List<MobilesDTO> list = service.validateAndSearch(price);

		req.setAttribute("data", list);



		return "success2";

	}
	@GetMapping("/searchbyram")
	public  String searchByRam(@RequestParam("ram") String ram,HttpServletRequest req) {
		List<MobilesDTO> list = service.validateAndSearch1(ram);

		req.setAttribute("data", list);
		return "success2";

	}
	@GetMapping("/searchbycolor")
	public  String searchByColor(@RequestParam("color") String color,HttpServletRequest req) {
		System.out.println(color);
		List<MobilesDTO> list = service.validateAndSearch2(color);

		req.setAttribute("data", list);



		return "success2";}
	@GetMapping("/searchbyall")
	public  String searchByAll(@RequestParam() String colors,String rams,String brand,int price,HttpServletRequest req) {
		List<MobilesDTO> list = service.validateAndSearch3(colors,rams,brand,price);
		if(list!=null) {
			req.setAttribute("data", list);
			return "success2";
		}else {
			req.setAttribute("data", "NO DATA FOUND WITH GIVEN DETAILS");

		}
		return null;}

	@GetMapping("/update/{id}")
	public  String updateById(@PathVariable("id") int id,HttpServletRequest req) {
		MobilesDTO dto = service.validateAndUpdate(id);

		req.setAttribute("lap", dto);	
		RedirectView view = new RedirectView();
		view.setUrl(req.getContextPath()+"/ ");
		return "update";}

	@PostMapping("/updateandsave")
	public String updateById1(@ModelAttribute MobilesDTO dto,HttpServletRequest req) {
		MobilesDTO dto1 = service.validateAndUpdate1(dto);

		req.setAttribute("mob", dto1);	


		return "success";

	}
	@GetMapping("/delete/{id}")
	public  RedirectView deleteById(@PathVariable("id") int id,HttpServletRequest req) {

		List<MobilesDTO> list = service.validateAndDelete(id);

		req.setAttribute("data", list);	
		RedirectView view = new RedirectView();
		view.setUrl(req.getContextPath());
		view.setUrl(req.getContextPath()+"/listoflaptops ");
		return view ;
	}

}
