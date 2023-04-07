package main.java.com.xworkz.qyalify.rest;

import org.springframework.stereotype.Component;

import lombok.NoArgsConstructor;
import lombok.ToString;
@ToString
@Component("sagar")
public class Sagar implements Restaurant {

	@Override
	public String serve() {
		// TODO Auto-generated method stub
		return "serving good ";
	}

}
