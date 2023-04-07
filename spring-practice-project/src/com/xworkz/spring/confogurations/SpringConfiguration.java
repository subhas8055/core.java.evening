package com.xworkz.spring.confogurations;


import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import com.xworkz.spring.bar.Bar;
import com.xworkz.spring.building.Building;
import com.xworkz.spring.channel.Channel;
import com.xworkz.spring.clients.Company;
import com.xworkz.spring.gun.Gun;
import com.xworkz.spring.hotel.Hotel;
import com.xworkz.spring.house.House;
import com.xworkz.spring.institute.Institute;
import com.xworkz.spring.juice.Juice;
import com.xworkz.spring.phone.Phone;
import com.xworkz.spring.team.Team;


@Configuration
@ComponentScan(basePackages = "com.xworkz.spring")
public class SpringConfiguration {
	

	public House getHouse () {
		
		return new House();
	}
	

	public Team getTeam() {
		
		return new Team();
	}
	
	@Bean(value = "channel")
	public Channel getChannel() {
		
		return new Channel();
	}
	
	@Bean(value = "phone")
	public Phone getPhone() {
		
		return new Phone();
	}
	

	public Hotel getHotel() {
		
		return new Hotel();
		
	}
	

	public Institute getInstitute() {
		
		return new Institute();
		}
	
	
	public Juice getJuice() {
		
		return new Juice();
	}
	
	public Company getCompany() {
		
		return new Company();
	}
	
		public Bar getBar() {
		
		return new Bar();
	}
	
	public Gun getGun() {
		return new Gun();
		}
	
	public Building getBuilding() {
		
		return new Building();
	}

}
