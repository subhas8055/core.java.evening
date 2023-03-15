package com.xworkz.jdbc.boot;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.xworkz.jdbc.dto.KshemaDTO;

public class KshemaRunner {

public static void main(String[] args) throws SQLException {
	KshemaDTO kshema= new KshemaDTO(2, "gokak", 8548058481l, "B.E");
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
		String querry="insert into kshema(id,place,mobilenumber,qualification)values(?,?,?,?)";
		PreparedStatement statement =connection.prepareStatement(querry);
		statement.setInt(1, kshema.getId());
		statement.setString(2, kshema.getPlace());
		statement.setLong(3, kshema.getMobilenumber());
		statement.setString(4, kshema.getQualification());
		int i=statement.executeUpdate();
		if(i!=0) {
			System.out.println(" insert done");
		}else {
			System.out.println("not done");
		}
//		=====================================================================
		ResultSet rs =statement.executeQuery("select * from kshema");
		while(rs.next()) {
			System.out.println("id :"+rs.getInt(1)+" "+"place :"+rs.getString(2)+"mobile number :"+rs.getLong(3)+"qualification :"+rs.getString(4));
		}
//		=====================================================================
		int j=statement.executeUpdate("update kshema set mobilenumber=8548058481 where id=1");
		if(j!=0) {
			System.out.println("update done");
		}else {
			System.out.println("update not done");
		}

//		=====================================================================
		int k=statement.executeUpdate("delete from kshema where id=1");
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
