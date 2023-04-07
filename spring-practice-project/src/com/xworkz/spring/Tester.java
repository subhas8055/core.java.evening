package com.xworkz.spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import com.xworkz.spring.bar.Bar;
import com.xworkz.spring.building.Building;
import com.xworkz.spring.channel.Channel;
import com.xworkz.spring.clients.Company;
import com.xworkz.spring.confogurations.SpringConfiguration;
import com.xworkz.spring.gun.Gun;
import com.xworkz.spring.hotel.Hotel;
import com.xworkz.spring.house.House;
import com.xworkz.spring.institute.Institute;
import com.xworkz.spring.juice.Juice;
import com.xworkz.spring.phone.Phone;
import com.xworkz.spring.team.Team;
 	 	
public class Tester {
public static void main(String[] args) {
		
		ApplicationContext applicationContext = new AnnotationConfigApplicationContext(SpringConfiguration.class);
		
		House house = applicationContext.getBean(House.class);
	System.out.println(house);
		
		Team team = applicationContext.getBean(Team.class);
		System.out.println(team);
		
		Channel channel = applicationContext.getBean(Channel.class);
		System.out.println(channel);
		
		Phone phone = applicationContext.getBean(Phone.class);
		System.out.println(phone); 
		
		Hotel hotel = applicationContext.getBean(Hotel.class);
		System.out.println(hotel);
		
		Institute institute = applicationContext.getBean(Institute.class);
		System.out.println(institute);
		
		Juice juice = applicationContext.getBean(Juice.class);
		System.out.println(juice);
		
		Company company = applicationContext.getBean(Company.class);
		System.out.println(company);
		
		Bar bar = applicationContext.getBean(Bar.class);
		System.out.println(bar);
		
		Gun gun = applicationContext.getBean(Gun.class);
		System.out.println(gun);
		
		Building building = applicationContext.getBean(Building.class);
		System.out.println(building);
	}

}
