package com.xworkz.mava;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Tester3 {
	
public static void main(String[] args) throws SQLException {
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/customers", "root", "Xworkzodc@123");
		Statement st=con.createStatement();
		String querry="insert into players(id,name,age,place,game) values(6,'anand',40,'india','chess')";
		int i=st.executeUpdate(querry);
		if(i!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
//		=============================================================================
		System.out.println("create  complete");
		ResultSet set=st.executeQuery("select * from players");
		while(set.next()) {
			System.out.println("id :"+set.getInt(1)+" "+"name :"+set.getString(2)+" "+"age :"+set.getInt(3)+" "+"place :"+set.getString(4)+" "+"game :"+set.getString(5));
		}
		System.out.println("read complete");
//		================================================================================
		int j= st.executeUpdate("update players set name='virat_kohli' where id=2");
		if(j!=0) {
			System.out.println("done");
		}else {
			System.out.println("not done");
		}
		System.out.println("update complete");
//		================================================================================
		int k =st.executeUpdate("delete  from players where id=4");
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
