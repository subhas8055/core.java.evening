package com.xworkz.player.repo;

import java.util.List;

import com.xworkz.player.dto.PlayerDTO;

public interface PlayerRepo {
	public PlayerDTO save(PlayerDTO dto);

	public List<PlayerDTO> get();
}
