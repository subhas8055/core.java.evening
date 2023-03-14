package com.xworkz.mava;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Tester1 {
public static void main(String[] args) throws SQLException {
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		System.out.println("=");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/customers", "root", "Xworkzodc@123");
		String querry="insert into pg(id,name,area,city,rent) values(9,'siddaganga_pg','vijaya_nagar ','banglore',5500)";
		Statement st = con.createStatement();
		int i=st.executeUpdate(querry);
		if(i!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
//		=============================================================================
		System.out.println("create  complete");
		ResultSet set=st.executeQuery("select * from pg");
		while(set.next()) {
			System.out.println("id :"+set.getInt(1)+" "+"name :"+set.getString(2)+" "+"Area :"+set.getString(3)+" "+"City :"+set.getString(4)+" "+"rent :"+set.getInt(5));
		}
		System.out.println("read complete");
//		================================================================================
		int j= st.executeUpdate("update pg set name='SLV_PG' where id=3");
		if(j!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
		System.out.println("update complete");
//		================================================================================
		int k =st.executeUpdate("delete  from pg where name='siddaganga_pg'");
		if(k!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
		System.out.println("delete complete");
		} catch (ClassNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
}
}
