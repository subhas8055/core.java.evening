package com.xworkz.mava;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Tester {

	public static void main(String[] args) throws SQLException  {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		Connection	con = DriverManager.getConnection("jdbc:mysql://localhost:3306/customers", "root", "Xworkzodc@123");
			String query="select * from customer";
				Statement st =con.createStatement();
				ResultSet rs=st.executeQuery(query);
				
				while(rs.next()) {
//					System.out.println(rs.next());
					System.out.println("id :"+rs.getInt(1)+" "+"name :"+rs.getString(2)+" "+"age :"+rs.getInt(3)+" "+"contactNo :"+rs.getLong(4)+" "+"location :"+rs.getString(5));
				}
				} catch (ClassNotFoundException e) {
					e.printStackTrace(); 
			
				
				}}
}
