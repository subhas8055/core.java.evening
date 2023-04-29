package com.xworkz.mvc.repo;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.xworkz.mvc.dto.LaptopDTO;
@Repository
public class LaptopRepoImpl implements LaptopRepo{

	@Override
	public LaptopDTO save(LaptopDTO dto) {
		LaptopDTO lap = new LaptopDTO();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
			String querry="insert into laptop values(?,?,?)";
			PreparedStatement statement =connection.prepareStatement(querry);
			
			statement.setString(1, dto.getName());
			statement.setString(2, dto.getRam());
			statement.setString(3, dto.getColor());
			
			int i=statement.executeUpdate();
			if(i!=0) {
			System.out.println("data added");
			lap=dto;
			
		}else {
			System.out.println("not added");
		}		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return lap;
	}
	@Override
	public List<LaptopDTO> getLaptop() {
		List<LaptopDTO> list = new ArrayList<LaptopDTO>();

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
			String querry="select * from laptop";
			PreparedStatement statement =connection.prepareStatement(querry);
			ResultSet rs=statement.executeQuery();
			while(rs.next()) {
					list.add(new LaptopDTO(rs.getInt(4), rs.getString(1), rs.getString(3), rs.getString(2)));
			}
			} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return list;
	}

}
