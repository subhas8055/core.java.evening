package com.xworkz.spring.phone;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@NoArgsConstructor
@ToString
@Component
public class Application {
	
	@Value("HotStar")
	private String app1;
	
	@Value("Youtube")
	private String app2;
}
