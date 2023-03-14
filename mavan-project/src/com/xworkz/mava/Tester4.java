package com.xworkz.mava;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Tester4 {
	
public static void main(String[] args) throws SQLException {
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/customers", "root", "Xworkzodc@123");
		Statement st=con.createStatement();
		String querry="insert into mobiles(id,brand,color,ram,price) values(6,'apple','silver',6,50000)";
		int i=st.executeUpdate(querry);
		if(i!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
//		=============================================================================
		System.out.println("create  complete");
		ResultSet set=st.executeQuery("select * from mobiles");
		while(set.next()) {
			System.out.println("id :"+set.getInt(1)+" "+"brand :"+set.getString(2)+" "+"color :"+set.getString(3)+" "+"ram :"+set.getInt(4)+" "+"price :"+set.getInt(5));
		}
		System.out.println("read complete");
//		================================================================================
		int j= st.executeUpdate("update mobiles set brand='oppo' where id=2");
		if(j!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
		System.out.println("update complete");
//		================================================================================
		int k =st.executeUpdate("delete  from mobiles where id=5");
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
