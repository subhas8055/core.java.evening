package main.java.com.xworkz.qyalify.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Component
@NoArgsConstructor
@ToString
@Data
public class Owner {
	@Autowired
	@Qualifier("sagar")
	 Restaurant restaurant;

}
