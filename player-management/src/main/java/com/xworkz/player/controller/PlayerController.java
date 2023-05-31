package com.xworkz.player.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.xworkz.player.dto.PlayerDTO;
import com.xworkz.player.service.PlayerService;

@Controller
@RequestMapping("/")
public class PlayerController {
	
	@Autowired
	PlayerService service;
	
	@PostMapping("/register")
	public String processAndSave(@ModelAttribute PlayerDTO dto,HttpServletRequest req){
		System.out.println("4");
		if(dto!=null) {
			System.out.println("5");
	service.ValidateAndSave(dto);
		req.setAttribute("player", dto.getName());
		return "success";
		}
	return "failure";	
	}
	@GetMapping("/listofplayers")
	public String getPlayers(HttpServletRequest req) {
		List<PlayerDTO> list =service.validateAndGet();
		req.setAttribute("playerdata", list);
		return "success2";
		
	}

}
