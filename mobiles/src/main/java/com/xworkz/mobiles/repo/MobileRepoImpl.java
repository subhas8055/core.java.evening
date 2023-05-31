package com.xworkz.mobiles.repo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.xworkz.mobiles.dto.MobilesDTO;
@Repository
public class MobileRepoImpl implements MobileRepo {
	@Autowired	
	EntityManagerFactory factory;
	@Override
	public void save(MobilesDTO dto) {
//		MobilesDTO mob =new MobilesDTO();
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="insert into mobile(brand,ram,color,price)values(?,?,?,?)";
//			PreparedStatement statement =connection.prepareStatement(querry);
//			
//			statement.setString(1, dto.getBrand());
//			statement.setString(2, dto.getRam());
//			statement.setString(3, dto.getColor());
//			statement.setInt(4, dto.getPrice());
//				System.out.println("8");
//			int i=statement.executeUpdate();
//			if(i!=0) {
//			System.out.println("data added");
//			mob=dto;
//			
//		}else {
//			System.out.println("not added");
//		}		} catch (ClassNotFoundException | SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		EntityManager manager = factory.createEntityManager();
		manager.getTransaction().begin();
		manager.persist(dto);
	}

	@Override
	public List<MobilesDTO> get() {
//		List<MobilesDTO> list = new ArrayList<MobilesDTO>();
//
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="select * from mobile";
//			PreparedStatement statement =connection.prepareStatement(querry);
//			ResultSet rs=statement.executeQuery();
//			System.out.println("11");
//			while(rs.next()) {
//					list.add(new MobilesDTO(rs.getInt(1),rs.getString(2), rs.getString(3), rs.getString(4), rs.getInt(5)));
//			}
//			} catch (ClassNotFoundException | SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}		return list;
//	}
//
//	@Override
//	public List<MobilesDTO> getByBrand(String brand) {
//		List<MobilesDTO> list = new ArrayList<MobilesDTO>();
//
//		try {
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/octoberbatch", "root", "Xworkzodc@123");
//			String querry="select * from mobile where brand=?";
//			PreparedStatement statement =connection.prepareStatement(querry);
//			statement.setString(1, brand);
//			ResultSet rs=statement.executeQuery();
//			System.out.println("11");
//			while(rs.next()) {
//					list.add(new MobilesDTO(rs.getInt(1),rs.getString(2), rs.getString(3), rs.getString(4), rs.getInt(5)));
//			}
//			} catch (ClassNotFoundException | SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}	
		EntityManager manager = factory.createEntityManager();
		Query query =manager.createNamedQuery("getAllMobiles");
		List<MobilesDTO> list = query.getResultList();
		return list;
	}

	@Override
	public List<MobilesDTO> getBYprice(int price) {
		EntityManager manager = factory.createEntityManager();
		Query query =manager.createNamedQuery("getAllMobilesByPrice");
		query.setParameter("price", price);
		List<MobilesDTO> list = query.getResultList();
		return list;		
	}

	@Override
	public List<MobilesDTO> getByRam(String ram) {
		EntityManager manager = factory.createEntityManager();
		Query query =manager.createNamedQuery("getAllMobilesByRam");
		query.setParameter("ram", ram);

		List<MobilesDTO> list = query.getResultList();
		return list;		
	}

	@Override
	public List<MobilesDTO> getByColor(String color) {
		EntityManager manager = factory.createEntityManager();
		Query query =manager.createNamedQuery("getAllMobilesByColor");
		query.setParameter("color", color);
		List<MobilesDTO> list = query.getResultList();
		return list;		
	}

	@Override
	public List<MobilesDTO> getByAll(String colors, String rams, String brand, int price) {
		EntityManager manager = factory.createEntityManager();
		Query query =manager.createNamedQuery("getAllMobilesByAll");
		query.setParameter("price", price);
		query.setParameter("color", colors);
		query.setParameter("ram", rams);
		query.setParameter("brand", brand);
		List<MobilesDTO> list = query.getResultList();
		return list;		
	}

	@Override
	public MobilesDTO updateById(int id) {
		EntityManager manager = factory.createEntityManager();
		Query query =manager.createNamedQuery("getAllMobilesById");
		query.setParameter("id", id);
		Object object =  query.getSingleResult();
		return (MobilesDTO) object;		
	}

	@Override
	public MobilesDTO update(MobilesDTO dto) {
		EntityManager manager = factory.createEntityManager();
		manager.getTransaction().begin();
		Query query =manager.createNamedQuery("updateById");
		query.setParameter("id", dto.getId());
		query.setParameter("brand", dto.getBrand());
		query.setParameter("color", dto.getColor());
		query.setParameter("ram", dto.getRam());
		query.setParameter("price", dto.getPrice());
		int i = query.executeUpdate();
		manager.getTransaction().commit();

		return dto;
	}

	@Override
	public List<MobilesDTO> delete(int id) {
		EntityManager manager = factory.createEntityManager();
		manager.getTransaction().begin();
		Query query =manager.createNamedQuery("deleteById");
		query.setParameter("id", id);
		int i = query.executeUpdate();
		manager.getTransaction().commit();
		Query query1 = manager.createNamedQuery("getAllMobiles");
		List<MobilesDTO>  list = query1.getResultList();
		
		
		return list;
	}

}
