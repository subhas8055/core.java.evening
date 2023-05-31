package com.xworkz.mvc.repo;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.Query;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.xworkz.mvc.dto.LaptopDTO;
@Repository
public class LaptopRepoImpl implements LaptopRepo{
	@Autowired
	EntityManagerFactory emf;

	@Override
	public void save(LaptopDTO dto) {
//		LaptopDTO lap = new LaptopDTO();
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="insert into laptop(name,ram,color)values(?,?,?)";
//			PreparedStatement statement =connection.prepareStatement(querry);
//
//			statement.setString(1, dto.getName());
//			statement.setString(2, dto.getRam());
//			statement.setString(3, dto.getColor());
//
//			int i=statement.executeUpdate();
//			if(i!=0) {
//				System.out.println("data added");
//				lap=dto;
//
//			}else {
//				System.out.println("not added");
//			}		} catch (ClassNotFoundException | SQLException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}

		
		EntityManager em = emf.createEntityManager();
		
		em.getTransaction().begin();
		em.persist(dto);
		em.getTransaction().commit();	

		
	}
	@Override
	public List<LaptopDTO> getLaptop() {
//		List<LaptopDTO> list = new ArrayList<LaptopDTO>();
//
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="select * from laptop";
//			PreparedStatement statement =connection.prepareStatement(querry);
//			ResultSet rs=statement.executeQuery();
//			while(rs.next()) {
//				list.add(new LaptopDTO(rs.getInt(4), rs.getString(1), rs.getString(3), rs.getString(2)));
//			}
//		} catch (ClassNotFoundException | SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//
//		return list;

		EntityManager em = emf.createEntityManager();
		Query query = em.createNamedQuery("getAllLaptop");
		 List<LaptopDTO> list =query.getResultList();
		 return list;
	}
	@Override
	public List<LaptopDTO> searchLaptop(String names) {
//		List<LaptopDTO> list = new ArrayList<LaptopDTO>();
//
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="select * from laptop where name=?";
//
//			PreparedStatement statement =connection.prepareStatement(querry);
//			statement.setString(1, names);
//			ResultSet rs=statement.executeQuery();
//			while(rs.next()) {
//				list.add(new LaptopDTO(rs.getInt(4), rs.getString(1), rs.getString(3), rs.getString(2)));
//			}
//		} catch (ClassNotFoundException | SQLException e) {
//			e.printStackTrace();
//		}
//
//		return list;
		EntityManager em = emf.createEntityManager();
		Query query = em.createNamedQuery("getAllLaptopByName");
		query.setParameter("name", names);
		 List<LaptopDTO> list =query.getResultList();
		 return list;
		
	}
	@Override
	public List<LaptopDTO> searchLaptop1(String ram) {
//		List<LaptopDTO> list = new ArrayList<LaptopDTO>();
//
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="select * from laptop where ram=?";
//
//			PreparedStatement statement =connection.prepareStatement(querry);
//			statement.setString(1, ram);
//			ResultSet rs=statement.executeQuery();
//			while(rs.next()) {
//				list.add(new LaptopDTO(rs.getInt(4), rs.getString(1), rs.getString(3), rs.getString(2)));
//			}
//		} catch (ClassNotFoundException | SQLException e) {
//			e.printStackTrace();
//		}
			EntityManager em = emf.createEntityManager();
			Query query =em.createNamedQuery("getAllLaptopByRam");
			query.setParameter("ram", ram);
			 List<LaptopDTO> list = query.getResultList();
		return list;
	}
	@Override
	public List<LaptopDTO> searchLaptop2(String color) {
//		List<LaptopDTO> list = new ArrayList<LaptopDTO>();
//
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="select * from laptop where color=?";
//
//			PreparedStatement statement =connection.prepareStatement(querry);
//			statement.setString(1, color);
//			ResultSet rs=statement.executeQuery();
//			while(rs.next()) {
//				list.add(new LaptopDTO(rs.getInt(4), rs.getString(1), rs.getString(3), rs.getString(2)));
//			}
//		} catch (ClassNotFoundException | SQLException e) {
//			e.printStackTrace();
//		}
		EntityManager em = emf.createEntityManager();
		System.out.println(color);
		Query query =em.createNamedQuery("getAllLaptopByColor");
		query.setParameter("color", color);
		 List<LaptopDTO> list = query.getResultList();

		return list;
	}
	@Override
	public LaptopDTO updateById(int id) {
//		LaptopDTO dto =new LaptopDTO();
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="select * from laptop  where id=?";
//
//			PreparedStatement statement =connection.prepareStatement(querry);
//			statement.setInt(1, id);
//			ResultSet rs=statement.executeQuery();
//			while(rs.next()) {
//				LaptopDTO dt	=new LaptopDTO(rs.getInt(4), rs.getString(1), rs.getString(3), rs.getString(2));
//				dto=dt;
//			}
//		} catch (ClassNotFoundException | SQLException e) {
//			e.printStackTrace();
//		}
		EntityManager em = emf.createEntityManager();
		Query query =em.createNamedQuery("getLaptopById");
		query.setParameter("id", id);
		Object dto = query.getSingleResult();

		return (LaptopDTO) dto  ;
	}
	@Override
	public LaptopDTO update(LaptopDTO dto) {
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="update laptop set name=? ,ram=?,color=? where id=?";
//
//			PreparedStatement statement =connection.prepareStatement(querry);
//			statement.setString(1, dto.getName());
//			statement.setString(2, dto.getRam());
//			statement.setString(3, dto.getColor());
//			statement.setInt(4, dto.getId());
//			int i=statement.executeUpdate();
//
//		} catch (ClassNotFoundException | SQLException e) {
//			e.printStackTrace();
//		}		return dto;
		EntityManager em = emf.createEntityManager();
		em.getTransaction().begin();
		Query query =em.createNamedQuery("updateById");
		query.setParameter("name", dto.getName());
		query.setParameter("ram", dto.getRam());
		query.setParameter("color",dto.getColor());
		query.setParameter("id", dto.getId());
		int i = query.executeUpdate();
		em.getTransaction().commit();
		return dto;
		
	}
	@Override
	public List<LaptopDTO> deleteById(int id) {
//		List<LaptopDTO> list = new ArrayList<LaptopDTO>();
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="delete from laptop where id=?";
//
//			PreparedStatement statement =connection.prepareStatement(querry);
//			statement.setInt(1, id);
//			int i = statement.executeUpdate();
//			ResultSet rs=statement.executeQuery("select * from laptop");
//			while(rs.next()) {
//
//				list.add(new LaptopDTO(rs.getInt(4), rs.getString(1), rs.getString(3), rs.getString(2)));
//			}
//
//		} catch (ClassNotFoundException | SQLException e) {
//			e.printStackTrace();
//		}
		EntityManager em = emf.createEntityManager();
		em.getTransaction().begin();
		Query query =em.createNamedQuery("deleteLaptopById");
		query.setParameter("id", id);
		int i = query.executeUpdate();
		em.getTransaction().commit();
		Query query1=em.createNamedQuery("getAllLaptop");
		 List<LaptopDTO> list = query1.getResultList();
		
		return list;
	}
	@Override
	public List<LaptopDTO> search(String colors, String rams, String names) {		
////		List<LaptopDTO> list = new ArrayList<LaptopDTO>();
////
////		try {
////			Class.forName("com.mysql.cj.jdbc.Driver");
////			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
////			String querry="select * from laptop  where color=? and ram=? and name=?";
////
////			PreparedStatement statement =connection.prepareStatement(querry);
////			statement.setString(1, colors);
////
////			statement.setString(2, rams);
////
////			statement.setString(3, names);
////
////			ResultSet rs=statement.executeQuery();
////			while(rs.next()) {
////				list.add(new LaptopDTO(rs.getInt(4), rs.getString(1), rs.getString(3), rs.getString(2)));
////			}	
////			
////	} catch (ClassNotFoundException | SQLException e) {
////		e.printStackTrace();
////	}		
	
	EntityManager em = emf.createEntityManager();
	Query query =em.createNamedQuery("getAllLaptopByAll");
	query.setParameter("color", colors);
	query.setParameter("ram", rams);
	query.setParameter("name", names);

	 List<LaptopDTO> list = query.getResultList();
	return list;
	}
}
