package com.xworkz.mava;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Tester5 {

public static void main(String[] args) throws SQLException {
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		System.out.println("=");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/customers", "root", "Xworkzodc@123");
		String querry="insert into bar(id,name) values(4,'ambika bar')";
		Statement st = con.createStatement();
		int i=st.executeUpdate(querry);
		if(i!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
//		=============================================================================
		System.out.println("create  complete");
		ResultSet set=st.executeQuery("select * from bar");
		while(set.next()) {
			System.out.println("id :"+set.getInt(1)+" "+"name :"+set.getString(2));
		}
		System.out.println("read complete");
//		================================================================================
		int j= st.executeUpdate("update bar set name='navarang' where id=1");
		if(j!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
		System.out.println("update complete");
//		================================================================================
		int k =st.executeUpdate("delete  from bar where name='ambika bar'");
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
