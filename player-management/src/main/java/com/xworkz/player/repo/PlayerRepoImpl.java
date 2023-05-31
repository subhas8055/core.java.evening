package com.xworkz.player.repo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.xworkz.player.dto.PlayerDTO;
@Repository
public class PlayerRepoImpl implements PlayerRepo {
	
	@Override
	public PlayerDTO save(PlayerDTO dto) {
		System.out.println("7");
		PlayerDTO play= new PlayerDTO();
		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
		String querry="insert into player(name,game,country,dob)values(?,?,?,?)";
		PreparedStatement statement =connection.prepareStatement(querry);
		
		statement.setString(1, dto.getName());
		statement.setString(2, dto.getGame());
		statement.setString(3, dto.getCountry());
		statement.setString(4, dto.getDob());

		int i=statement.executeUpdate();
		if(i!=0) {
		System.out.println("data added");
		play=dto;
		
	}else {
		System.out.println("not added");
	}		} catch (ClassNotFoundException | SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
		return play;
		
	}

	@Override
	public List<PlayerDTO> get() {
		List<PlayerDTO> list = new ArrayList<PlayerDTO>();

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
			String querry="select * from player";
			PreparedStatement statement =connection.prepareStatement(querry);
			ResultSet rs=statement.executeQuery();
			while(rs.next()) {
					list.add(new PlayerDTO(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),  rs.getString(5)));
			}
			} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		return list;
	}

}
