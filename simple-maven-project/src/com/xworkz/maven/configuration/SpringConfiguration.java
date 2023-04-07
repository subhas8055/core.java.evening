package com.xworkz.maven.configuration;

import java.util.Scanner;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.xworkz.maven.dto.FoodStallDTO;
import com.xworkz.maven.dto.GlassDTO;
import com.xworkz.maven.dto.LaptopDTO;
import com.xworkz.maven.dto.PersonDTO;
import com.xworkz.maven.dto.TrainDTO;
import com.xworkz.maven.dto.WireDTO;

@Configuration
public class SpringConfiguration {
@Bean(name="a")
	public PersonDTO getPersonDTO() {
		PersonDTO person = new PersonDTO();
		person.setId(1);
		person.setName("ABD");
		person.setAge(39);
		return person;
	}
@Bean(name="b")
public PersonDTO getPersonDTO1() {
	PersonDTO person = new PersonDTO();
	person.setId(2);
	person.setName("VIRAT");
	person.setAge(36);
	return person;
}

@Bean(name="c")
public PersonDTO getPersonDTO2() {
PersonDTO person = new PersonDTO();
person.setId(3);
person.setName("GAYLE");
person.setAge(42);
return person;
}

@Bean(name="d")
public PersonDTO getPersonDTO3() {
PersonDTO person = new PersonDTO();
person.setId(4);
person.setName("MAXI");
person.setAge(34);
return person;
}

@Bean(name="e")
public PersonDTO getPersonDTO4() {
PersonDTO person = new PersonDTO();
person.setId(5);
person.setName("FAF");
person.setAge(34);
return person;
}

@Bean(name="f")
	public FoodStallDTO getFoodStallDTO() {
		FoodStallDTO food =new FoodStallDTO();
		food.setId(1);
		food.setName("qwer");
		food.setPrice(45000);
		
		return food;
	}

@Bean(name="g")
	public FoodStallDTO getFoodStallDTO1() {
		FoodStallDTO food =new FoodStallDTO();
		food.setId(2);
		food.setName("tyui");
		food.setPrice(56789);
		
		return food;
	}

@Bean(name="h")
	public FoodStallDTO getFoodStallDTO2() {
		FoodStallDTO food =new FoodStallDTO();
		food.setId(3);
		food.setName("opas");
		food.setPrice(35790);
		
		return food;
	}

@Bean(name="i")
	public FoodStallDTO getFoodStallDTO3() {
		FoodStallDTO food =new FoodStallDTO();
		food.setId(4);
		food.setName("dfgh");
		food.setPrice(78900);
		
		return food;
	}

@Bean(name="j")
	public FoodStallDTO getFoodStallDTO4() {
		FoodStallDTO food =new FoodStallDTO();
		food.setId(5);
		food.setName("jklz");
		food.setPrice(49565);
		
		return food;
	}
@Bean(name="k")
	public GlassDTO getGlassDTO() {
		GlassDTO dto = new GlassDTO();
		
		dto.setId(1);
		dto.setBrand("AB");
		dto.setPrice(2000);
		return dto;
	}

@Bean(name="l")
	public GlassDTO getGlassDTO1() {
		GlassDTO dto = new GlassDTO();
		
		dto.setId(2);
		dto.setBrand("BC");
		dto.setPrice(2001);
		return dto;
	}

@Bean(name="m")
	public GlassDTO getGlassDTO2() {
		GlassDTO dto = new GlassDTO();
		
		dto.setId(3);
		dto.setBrand("CD");
		dto.setPrice(2003);
		return dto;
	}

@Bean(name="n")
	public GlassDTO getGlassDTO3() {
		GlassDTO dto = new GlassDTO();
		
		dto.setId(4);
		dto.setBrand("DE");
		dto.setPrice(2005);
		return dto;
	}

@Bean(name="o")
	public GlassDTO getGlassDTO4() {
		GlassDTO dto = new GlassDTO();
		
		dto.setId(5);
		dto.setBrand("EF");
		dto.setPrice(2007);
		return dto;
	}
@Bean(name="p")	
	public LaptopDTO getLaptopDTO() {
		LaptopDTO lap = new LaptopDTO();
		lap.setId(1);
		lap.setBrand("hp");
		lap.setPrice(80000);	
		lap.setRam("16gb");
		return lap;
		
	}
@Bean(name="q")	
public LaptopDTO getLaptopDTO1() {
	LaptopDTO lap = new LaptopDTO();
	lap.setId(2);
	lap.setBrand("dell");
	lap.setPrice(70000);	
	lap.setRam("16gb");
	return lap;
	
}
@Bean(name="r")	
public LaptopDTO getLaptopDTO2() {
	LaptopDTO lap = new LaptopDTO();
	lap.setId(3);
	lap.setBrand("lenovo");
	lap.setPrice(60000);	
	lap.setRam("16gb");
	return lap;
	
}
@Bean(name="s")	
public LaptopDTO getLaptopDTO3() {
	LaptopDTO lap = new LaptopDTO();
	lap.setId(4);
	lap.setBrand("asus");
	lap.setPrice(50000);	
	lap.setRam("16gb");
	return lap;
	
}
@Bean(name="t")	
public LaptopDTO getLaptopDTO4() {
	LaptopDTO lap = new LaptopDTO();
	lap.setId(5);
	lap.setBrand("apple");
	lap.setPrice(90000);	
	lap.setRam("16gb");
	return lap;
	
}

@Bean(name="u")
	public TrainDTO getTrainDTO() {
		TrainDTO train = new TrainDTO();
		train.setId(1);
		train.setName("rajadhani");
		train.setSrc("banglore");	
		train.setDestn("belgaum");
		
		return train;
		
	}

@Bean(name="v")
	public TrainDTO getTrainDTO1() {
		TrainDTO train = new TrainDTO();
		train.setId(2);
		train.setName("sss");
		train.setSrc("banglore");	
		train.setDestn("hubli");
		
		return train;
		
	}

@Bean(name="w")
	public TrainDTO getTrainDTO2() {
		TrainDTO train = new TrainDTO();
		train.setId(3);
		train.setName("sbc exp");
		train.setSrc("banglore");	
		train.setDestn("belgaum");
		
		return train;
		
	}

@Bean(name="x")
	public TrainDTO getTrainDTO3() {
		TrainDTO train = new TrainDTO();
		train.setId(4);
		train.setName("rajadhani");
		train.setSrc("belgaum");	
		train.setDestn("banglore");
				return train;
		
	}

@Bean(name="y")
	public TrainDTO getTrainDTO4() {
		TrainDTO train = new TrainDTO();
		train.setId(5);
		train.setName("bombay exp");
		train.setSrc("banglore");	
		train.setDestn("mumbai");
		
		return train;
		
	}

@Bean(name="z")
	public WireDTO getWireDTO() {
		WireDTO wire = new WireDTO();
		wire.setId(1);
		wire.setBrand("finolex");
		wire.setPrice(23);
		wire.setDia(1);
		return wire;
		
	}
@Bean(name="aa")
public WireDTO getWireDTO1() {
	WireDTO wire = new WireDTO();
	wire.setId(2);
	wire.setBrand("RED");
	wire.setPrice(21);
	wire.setDia(1);
	return wire;
	
}
@Bean(name="ab")
public WireDTO getWireDTO2() {
	WireDTO wire = new WireDTO();
	wire.setId(3);
	wire.setBrand("GREEN");
	wire.setPrice(23);
	wire.setDia(1);
	return wire;
	
}

@Bean(name="ac")
public WireDTO getWireDTO3() {
	WireDTO wire = new WireDTO();
	wire.setId(4);
	wire.setBrand("BLUE");
	wire.setPrice(19);
	wire.setDia(1);
	return wire;
	
}

@Bean(name="ad")
public WireDTO getWireDTO4() {
	WireDTO wire = new WireDTO();
	wire.setId(5);
	wire.setBrand("black");
	wire.setPrice(23);
	wire.setDia(1);
	return wire;
	
}

@Bean(name="ae")
public Integer getInteger() {
	return 12;
}
@Bean(name="af")
public Integer getInteger1() {
	return 34;
}
@Bean(name="ag")
public Integer getInteger2() {
	return 56;
}
@Bean(name="ah")
public Integer getInteger3() {
	return 78;
}
@Bean(name="ai")
public Integer getInteger4() {
	return 90;
}
@Bean
public Double getDouble() {
	return 12.34;
}
@Bean
public Byte getByte() {
	return 127;
}
@Bean(name="aj")
public Short getShort() {
	return 32767;
}
@Bean(name="ak")
public Short getShort1() {
	return 32766;
}
@Bean(name="al")
public Short getShort2() {
	return 32765;
}
@Bean(name="am")
public Short getShort3() {
	return 32764;
}
@Bean(name="an")
public Short getShort4() {
	return 32763;
}
@Bean
public Long getLong() {
	return 21470987654L;
}
@Bean
public Float getFloat() {
	return 12864.34f;
}
@Bean(name="ao")
public Character getCharacter() {
	return 'S';
}
@Bean(name="ap")
public Character getCharacter1() {
	return 'U';
}
@Bean(name="aq")
public Character getCharacter2() {
	return 'B';
}
@Bean(name="ar")
public Character getCharacter3() {
	return 'H';
}
@Bean(name="as")
public Character getCharacter4() {
	return 'A';
}

@Bean
public Boolean getBoolean() {
	return true;
}

@Bean(name="at")
public String getString() {
	return "Strong";
}

@Bean(name="au")
public String getString1() {
	return "Strongg";
}

@Bean(name="av")
public String getString2() {
	return "Stronggg";
}

@Bean(name="aw")
public String getString3() {
	return "Strongggg";
}

@Bean(name="ax")
public String getString4() {
	return "Stronggggg";
}

@Bean
public Scanner getScanner() {
	Scanner sc=new Scanner(System.in);

	return sc;
	
}

}
