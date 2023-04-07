package com.xworkz.spring.channel;

import org.springframework.beans.factory.annotation.Autowired;
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
public class Channel {
	
	@Value("Star Sports kannada")
	private String channelName;
	
	@Autowired
	private Viewers viewers ;



}
