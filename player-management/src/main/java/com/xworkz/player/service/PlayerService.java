package com.xworkz.player.service;

import java.util.List;

import com.xworkz.player.dto.PlayerDTO;

public interface PlayerService {
	public PlayerDTO ValidateAndSave(PlayerDTO dto);

	public List<PlayerDTO> validateAndGet();
}
