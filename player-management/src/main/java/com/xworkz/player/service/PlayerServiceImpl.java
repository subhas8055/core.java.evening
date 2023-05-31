package com.xworkz.player.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xworkz.player.dto.PlayerDTO;
import com.xworkz.player.repo.PlayerRepo;

@Service
public class PlayerServiceImpl implements PlayerService {
	@Autowired
	PlayerRepo repo;
	
	@Override
	public PlayerDTO ValidateAndSave(PlayerDTO dto) {
		System.out.println("6");
		return repo.save(dto);
	}

	@Override
	public List<PlayerDTO> validateAndGet() {
		List<PlayerDTO> list =repo.get();
		
		return list;
	}

}
