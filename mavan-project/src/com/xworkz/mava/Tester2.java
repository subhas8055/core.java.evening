package com.xworkz.mava;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Tester2 {
public static void main(String[] args) throws SQLException {
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/customers", "root", "Xworkzodc@123");
		Statement st=con.createStatement();
		String querry="insert into shoes values(3,'nike',10,1400,'blcak')";
		int i=st.executeUpdate(querry);
		if(i!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
//		=============================================================================
		System.out.println("create  complete");
		ResultSet set=st.executeQuery("select * from shoes");
		while(set.next()) {
			System.out.println("id :"+set.getInt(1)+" "+"brand :"+set.getString(2)+" "+"size :"+set.getInt(3)+" "+"price :"+set.getInt(4)+" "+"color :"+set.getString(5));
		}
		System.out.println("read complete");
//		================================================================================
		int j= st.executeUpdate("update shoes set brand='woodland' where id=2");
		if(j!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
		System.out.println("update complete");
//		================================================================================
		int k =st.executeUpdate("delete  from shoes where brand='siddaganga_pg'");
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
