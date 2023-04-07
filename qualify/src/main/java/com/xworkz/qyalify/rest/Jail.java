package main.java.com.xworkz.qyalify.rest;

import org.springframework.stereotype.Component;

import lombok.NoArgsConstructor;
import lombok.ToString;

@Component("jail")
@ToString
public class Jail  implements Restaurant{

	@Override
	public String serve() {
		return "serving good food";
	}

}
