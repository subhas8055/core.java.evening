package com.xworkz.jdbc.boot;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.xworkz.jdbc.dto.SubhasDTO;
import com.xworkz.jdbc.dto.VishalDTO;

public class VIshalRunner {


public static void main(String[] args) throws SQLException {
	VishalDTO vishal= new VishalDTO(1, "rabkavi", 934762633l, "B.com");
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
		String querry="insert into vishal(id,place,mobilenumber,qualification)values(?,?,?,?)";
		PreparedStatement statement =connection.prepareStatement(querry);
		statement.setInt(1, vishal.getId());
		statement.setString(2, vishal.getPlace());
		statement.setLong(3, vishal.getMobilenumber());
		statement.setString(4, vishal.getQualification());
		int i=statement.executeUpdate();
		if(i!=0) {
			System.out.println(" insert done");
		}else {
			System.out.println("not done");
		}
//		=====================================================================
		ResultSet rs =statement.executeQuery("select * from vishal");
		while(rs.next()) {
			System.out.println("id :"+rs.getInt(1)+" "+"place :"+rs.getString(2)+" "+"mobile number :"+rs.getLong(3)+"qualification :"+rs.getString(4));
		}
//		=====================================================================
		int j=statement.executeUpdate("update vishal set mobilenumber=8548058481 where id=1");
		if(j!=0) {
			System.out.println("update done");
		}else {
			System.out.println("update not done");
		}

//		=====================================================================
		int k=statement.executeUpdate("delete from vishal where id=1");
		if(k!=0) {
			System.out.println("delete done");
		}else {
			System.out.println("delete not done");
		}
		
	} catch (ClassNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
}
}


